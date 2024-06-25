from flask import Flask, request, jsonify, render_template
from keras.models import load_model
import numpy as np
from PIL import Image

app = Flask(__name__)


# Load your AI model
model = load_model("old_keras_model.h5", compile=False)
class_names = open("old_labels.txt", "r").readlines()
# Define a function to preprocess the image
def preprocess_image(image):
    # Load the image
    img = image

    # Resize the image to match the input size expected by the model
    img = img.resize((224, 224))

    # Convert the image to an array
    img_array = np.array(img)

    # Normalize the image data
    img_array = img_array / 255.0

    # Expand the dimensions to match the input shape expected by the model
    img_array = np.expand_dims(img_array, axis=0)

    return img_array

@app.route('/', methods=['POST'])
def upload_file():
    if request.method == 'POST':

        if 'file' not in request.files:
            return jsonify({'error': 'No file part'})
        file = request.files['file']
        if file.filename == '':
            return jsonify({'error': 'No selected file'})
        if file:

            image = file.read()

            # need test in this part
            image = Image.open(image).convert("RGB")


            processed_image = preprocess_image(image)
            prediction = model.predict(processed_image)
            index = np.argmax(prediction)
            class_name = class_names[index]
            confidence_score = prediction[0][index]


            # Return the prediction as a response
            return jsonify({'prediction': class_name},{"Confidence Score:", confidence_score})


if __name__ == '__main__':
    app.run(debug=True)
