#!/usr/bin/env

DIFF_FILE_PATH = "./diff.txt"
IMAGE_FILE_PATH = "./images.txt"

images = []

with open(DIFF_FILE_PATH, "r") as diffFile:
    lines = diffFile.readlines()
    for line in lines:
        if "Pull" in line:
            images.append("eu.gcr.io/" + line.split()[2])

if (len(images) > 0):
    with open(IMAGE_FILE_PATH, "w") as imageFile:
        imageFile.write("\n".join(images))