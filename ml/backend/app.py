import io
import torchvision.transforms as transforms
import os
import sys
import torch
import torch.nn.functional as F
from PIL import Image
from flask import Flask, jsonify, request
from torchvision.models import resnet18
os.sys.path.insert(0, os.getcwd())


app = Flask(__name__)

resnet_model = resnet18(num_classes=2)
resnet_model.load_state_dict(torch.load("assets/models/resnet18.pth"))
resnet_model.eval()


@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':

        file = request.files['file']

        img_bytes = file.read()

        prob, class_num = get_prediction(image_bytes=img_bytes)

    return jsonify({'prob': prob, 'class': class_num})

def transform_image(image_bytes):
    my_transforms = transforms.Compose([
        transforms.Resize(112),
        transforms.ToTensor(),
        transforms.Normalize([0.4722, 0.3625, 0.3350], [0.2181, 0.1921, 0.1855])
    ])
    image = Image.open(io.BytesIO(image_bytes))
    return my_transforms(image).unsqueeze(0)

def get_prediction(image_bytes):
    tensor = transform_image(image_bytes=image_bytes)
    outputs = resnet_model.forward(tensor)
    _, y_hat = outputs.max(1)
    probs = F.softmax(outputs[0])
    prob = probs[1]
    return prob.item(), y_hat.item()


if __name__ == '__main__':
    app.run()