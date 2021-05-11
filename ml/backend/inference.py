from flask import Flask,Blueprint,request,render_template,jsonify

import requests
import torch
import torch.nn as nn
from torchvision.models import resnet18
import cv2
import os
import sys
os.sys.path.insert(0, os.getcwd())

from ml.models.mobilenetv2 import mobilenetv2





mod=Blueprint('backend', __name__,template_folder='templates', static_folder='./static')
UPLOAD_URL = 'http://192.168.1.103:5000/static/'

resnet_model = resnet18(num_classes=2)
resnet_model.load_state_dict(torch.load("assets/models/resnet18.pth"))

@mod.route('/predict')
def predict():
    if request.method == 'POST':
        pass
