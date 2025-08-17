from PIL import Image
import os

# Input & output folders
input_folder = "input_pngs"
output_folder = "output_pngs"
os.makedirs(output_folder, exist_ok=True)

for file_name in os.listdir(input_folder):
    if file_name.lower().endswith(".png"):
        img = Image.open(os.path.join(input_folder, file_name)).convert("RGBA")
        
        # Create a transparent 64x64 background
        new_img = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
        
        # Scale down if needed while keeping aspect ratio
        img.thumbnail((64, 64), Image.LANCZOS)
        
        # Center the image
        x = (64 - img.width) // 2
        y = (64 - img.height) // 2
        new_img.paste(img, (x, y), img)
        
        # Save result
        new_img.save(os.path.join(output_folder, file_name))
