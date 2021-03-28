import os
os.chdir('/scratch/users/nnayal17/moody_much/MoodyMuch/ml')

import cv2
import numpy as np
import random
import torch
from torch.utils.data import Dataset
import matplotlib.image as mpimg
import matplotlib.pyplot as plt
from models.blazeface import BlazeFace

class AffWild2ExprDataset(Dataset):
    
    dataset_path = '/datasets/affwild2_latest'

    videos_path = os.path.join(dataset_path, 'videos')
    videos_batch1_path = os.path.join(videos_path, 'batch1')
    videos_batch2_path = os.path.join(videos_path, 'batch2')

    cropped_images_path = os.path.join(dataset_path, 'cropped_images')
    cropped_images_batch1_path = os.path.join(cropped_images_path, 'batch1')
    cropped_images_batch2_path = os.path.join(cropped_images_path, 'batch2')

    cropped_aligned_images_path = os.path.join(dataset_path, 'cropped_aligned_images')

    expr_set_train = os.path.join(dataset_path, 'annotations/EXPR_Set/Training_Set')
    expr_set_valid = os.path.join(dataset_path, 'annotations/EXPR_Set/Validation_Set')
    
    class_num_to_name = {
        0: 'Neutral',
        1: 'Anger',
        2: 'Disgust',
        3: 'Fear',
        4: 'Happiness',
        5: 'Sadness',
        6: 'Surprise'
    }
    
    class_name_to_num = {
        'Neutral':0,
        'Anger':1,
        'Disgust':2,
        'Fear':3,
        'Happiness':4,
        'Sadness':5,
        'Surprise':6
    }
    
    binary_class = {
        1: 'Positive',
        0: 'Negative'
    }
    
    
    def __init__(
        self, 
        train: bool = True, 
        skip: int = 0, 
        remove_mismatch: bool = False, 
        transform=None, 
        compress=False,
        binary=False
    ):
        
        self.skip = skip
        self.train = train
        self.compress = compress
        self.transform = transform
        self.binary = binary
        self.label_names = None
        self.labels_root = None
        self.random_seed(8)
        
        if train:
            self.label_names = os.listdir(self.expr_set_train)
            self.labels_root = self.expr_set_train
        else:
            self.label_names = os.listdir(self.expr_set_valid)
            self.labels_root = self.expr_set_valid
        
        cropped_aligned_images = os.listdir(self.cropped_aligned_images_path)
        self.video_names = self.list_intersection(self.label_names, cropped_aligned_images)
        
        self.video_names = sorted(self.video_names)
        self.label_names = sorted(self.label_names)
        
        self.videos = []
        self.labels = []
        
        positive_frames, negative_frames = [], []
        positive_labels, negative_labels = [], []
        
        for k, vid in enumerate(self.video_names):
            
            video_frames_path = os.path.join(self.cropped_aligned_images_path, vid)
            video_frames = os.listdir(video_frames_path)
            label_frames = self.read_labels(os.path.join(self.labels_root, self.label_names[k]))
            
            if remove_mismatch and len(video_frames) != len(label_frames):
                continue
            elif len(video_frames) != len(label_frames):
                min_length = min(len(video_frames), len(label_frames))
                video_frames = video_frames[:min_length]
                label_frames = label_frames[:min_length]
                
            video_frames = np.array(sorted(video_frames))
            label_frames = np.array(label_frames)
            
            remove_mask = label_frames != -1
            
            video_frames = video_frames[remove_mask]
            label_frames = label_frames[remove_mask]
            
            if compress:
                
                for i, frame in enumerate(video_frames):

                    if i % (skip + 1) != 0:
                        continue
                    
                    if binary:
                        
                        class_name = self.class_num_to_name[label_frames[i]]
                        if class_name in ['Neutral', 'Surprise']:
                            continue;
                        
                        if class_name == 'Happiness':
                            positive_frames.append(os.path.join(video_frames_path, frame))
                            positive_labels.append(1)
                        else:
                            negative_frames.append(os.path.join(video_frames_path, frame))
                            negative_labels.append(0)
                        
                    else:
                        self.videos.append(os.path.join(video_frames_path, frame))
                        self.labels.append(label_frames[i])

            else:
                video = []
                label = []
                for i, frame in enumerate(video_frames):

                    if i % (skip + 1) != 0:
                        continue

                    video.append(os.path.join(video_frames_path, frame))
                    label.append(label_frames[i])

                self.videos.append(video)
                self.labels.append(label)
        
        if binary:
            pos_len = len(positive_frames)
            neg_len = len(negative_frames)
            min_len = min(pos_len, neg_len)
            
            self.videos = np.asarray(positive_frames[:min_len] + negative_frames[:min_len])
            self.labels = np.asarray(positive_labels[:min_len] + negative_labels[:min_len])
            
            idx = np.arange(2 * min_len)
            np.random.shuffle(idx)
            
            self.videos = self.videos[idx]
            self.labels = self.labels[idx]
            
        self.length = len(self.videos)
    
    
    def __len__(self):
        return self.length
    
    def __getitem__(self, index):
        
        
        if self.compress:
            img = mpimg.imread(self.videos[index])
            if self.transform:
                img = self.transform(img)
            
            return img, self.labels[index]
        
        frames = []
        for i in range(len(self.videos[index])):
            img = mpimg.imread(self.videos[index][i])
            if self.transform:
                img = self.transform(img)
            frames.append(img)
        
        frames = np.asarray(frames)
        frames = torch.from_numpy(frames.astype(np.float32))
        if len(frames.size()) != 4:
            print(f'WARNING: Frames of Size {frames.shape} was found')
        frames = frames.permute(0, 3, 1, 2)
        
        labels = np.asarray(self.labels[index])
        labels = torch.from_numpy(labels)
        
        return frames, label
     
    def list_intersection(self, lst1, lst2):
    
        extensions = ['.txt', '.mp4', '.avi']

        for i in range(len(lst1)):
            if lst1[i][-4:] in extensions:
                lst1[i] = lst1[i][:-4]

        for i in range(len(lst2)):
            if lst2[i][-4:] in extensions:
                lst2[i] = lst2[i][:-4]


        lst3 = [value for value in lst1 if value in lst2]
        return lst3   
    
    def read_labels(self, path):
        
        f = open(path + '.txt', 'r')
        labels = []
        skip_first = True
        for line in f:
            if skip_first:
                skip_first = False
                continue
            labels.append(int(line[:-1]))

        return labels
    
    def random_seed(self, seed):
        """Set seed"""
        random.seed(seed)
        np.random.seed(seed)
        torch.manual_seed(seed)
        if torch.cuda.is_available():
            torch.cuda.manual_seed(seed)
            torch.cuda.manual_seed_all(seed)
            torch.backends.cudnn.deterministic = True
            torch.backends.cudnn.benchmark = False
        os.environ["PYTHONHASHSEED"] = str(seed)
        

class AffWild2VADataset(Dataset):
    
    affwild2_path = '/datasets/affwild2'
    affwild2_videos = os.path.join(affwild2_path, 'videos/train')
    affwild2_arousal = os.path.join(affwild2_path, 'annotations/train/arousal')
    affwild2_valence = os.path.join(affwild2_path, 'annotations/train/valence')
    
    def __init__(self, train=True, split=0.7, skip=0):
        super().__init__()
        
        self.videos = sorted(os.listdir(self.affwild2_videos))
        self.arousal = sorted(os.listdir(self.affwild2_arousal))
        self.valence = sorted(os.listdir(self.affwild2_valence))
        self.train = train
        self.skip = skip
        
        data_size = len(self.videos)
        split_point = int(data_size * split)
        
        if train:
            self.videos = self.videos[:split_point]
            self.arousal = self.arousal[:split_point]
            self.valence = self.valence[:split_point]
        else:
            self.videos = self.videos[split_point:]
            self.arousal = self.arousal[split_point:]
            self.valence = self.valence[split_point:]
        
        self.len = len(self.videos)
        
        
#         self.device = torch.device("cpu")
#         self.blazeface = BlazeFace().to(self.device)
#         self.blazeface.load_weights("weights/blazeface.pth")
#         self.blazeface.load_anchors("weights/anchors.npy")
        
#         self.blazeface.to(self.device)
        
        
    def __len__(self):
        return self.len
    
    def __getitem__(self, index):
        
        face_frames = self.read_frames(os.path.join(self.affwild2_videos, self.videos[index]))
        
        arousal = self.read_file(os.path.join(self.affwild2_arousal, self.arousal[index]))
        valence = self.read_file(os.path.join(self.affwild2_valence, self.valence[index]))
        
        face_frames = torch.from_numpy(face_frames.astype(np.float32))
        arousal = torch.from_numpy(arousal.astype(np.float32))
        valence = torch.from_numpy(valence.astype(np.float32))
        
        return face_frames, arousal, valence
    
    def read_file(self, path):
        
        f = open(path, 'r')
        label = []
        for i, line in enumerate(f):
            if i % (self.skip + 1) != 0:
                continue
            label.append(line[:-1])
            
        return np.asarray(label)
    
#     def get_face_frames(self, path):
        
#         frames = self.read_frames(path)
#         faces = np.zeros((frames.shape[0], 128, 128, 3))
        
#         for i, frame in enumerate(frames):
            
#             detections = self.blazeface.predict_on_image(frame)
#             face = self.get_face(frame, detections)
#             faces[i] = cv2.resize(face, (128, 128))
            
#         return faces
    
#     def get_face(self, img, detections):
    
#         if isinstance(detections, torch.Tensor):
#             detections = detections.cpu().numpy()

#         if detections.ndim == 1:
#             detections = np.expand_dims(detections, axis=0)

        
#         if detections.shape[0] == 0:
#             raise ValueError("No Face Detected")
            
#         elif detections.shape[0] > 1:
#             print(f"WARNING: {detections.shape[0]} Faces were detected")
        
#         for i in range(detections.shape[0]):
#             ymin = detections[i, 0] * img.shape[0]
#             xmin = detections[i, 1] * img.shape[1]
#             ymax = detections[i, 2] * img.shape[0]
#             xmax = detections[i, 3] * img.shape[1]
            
#         return img[int(ymin):int(ymax), int(xmin):int(xmax), :]
    
    def read_frames(self, path):
    
        vid = cv2.VideoCapture(path)
        frame_count = int(vid.get(cv2.CAP_PROP_FRAME_COUNT))
        fps = vid.get(cv2.CAP_PROP_FPS)
        
        frames = []
        for i in range(frame_count):
            
            if i % (self.skip + 1) != 0:
                continue
            
            ret, frame = vid.read()
            if not ret:
                break
                
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frames.append(cv2.resize(frame, (128, 128)))

        vid.release()
        frames = np.asarray(frames)
        
        return frames