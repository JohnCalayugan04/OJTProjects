from fastapi import FastAPI, File, UploadFile, HTTPException
import face_recognition
import numpy as np
from PIL import Image, ImageOps, UnidentifiedImageError
import io
import traceback

app = FastAPI(title="Face Embedder API", version="1.0.0")


@app.post("/embed-face/")
async def embed_face(file: UploadFile = File(...)):
    """
    Accepts an image file, detects the first face, and returns its embedding vector.
    """
    try:
        # Read uploaded file
        image_data = await file.read()

        try:
            # Open with Pillow
            image = Image.open(io.BytesIO(image_data))
            image = ImageOps.exif_transpose(image)  # Fix orientation
            image = image.convert("RGB")  # Force 8-bit RGB
        except UnidentifiedImageError:
            raise HTTPException(status_code=400, detail="Invalid image format")
        except Exception as e:
            print("[ERROR] Image processing failed:", e)
            traceback.print_exc()
            raise HTTPException(status_code=400, detail="Cannot process image")

        # Resize if very large
        max_size = 800
        if max(image.size) > max_size:
            image.thumbnail((max_size, max_size))

        # Convert to numpy (uint8, contiguous array)
        np_image = np.ascontiguousarray(np.array(image, dtype=np.uint8))

        print("[DEBUG] final dtype:", np_image.dtype)
        print("[DEBUG] final shape:", np_image.shape)
        print("[DEBUG] final contiguous:", np_image.flags['C_CONTIGUOUS'])

        # Face detection
        try:
            face_locations = face_recognition.face_locations(np_image, model="hog", number_of_times_to_upsample=0)
        except RuntimeError as e:
            print("[ERROR] Face detection failed:", e)
            raise HTTPException(status_code=500, detail="Face detection failed")

        if not face_locations:
            raise HTTPException(status_code=400, detail="No face detected in image")

        # Face embedding
        encodings = face_recognition.face_encodings(np_image, face_locations)
        if not encodings:
            raise HTTPException(status_code=400, detail="Face detected but embedding failed")

        return {
            "embedding": encodings[0].tolist(),
            "face_detected": True,
            "num_faces": len(face_locations),
        }

    except HTTPException:
        raise
    except Exception as e:
        print("[ERROR] Unexpected error:", e)
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")
