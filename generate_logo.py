#!/usr/bin/env python3
"""
Script to generate Business Code logo as PNG
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_business_code_logo(size=512):
    # Create a white background
    img = Image.new('RGB', (size, size), 'white')
    draw = ImageDraw.Draw(img)
    
    # Calculate proportions
    margin = size // 10
    icon_size = size // 3
    icon_margin = (size - icon_size) // 2
    
    # Draw outer brackets (green border)
    outer_rect = [margin, margin, size - margin, size - margin]
    draw.rectangle(outer_rect, outline='#4CAF50', width=size//64)
    
    # Draw inner brackets
    inner_margin = margin + size // 20
    inner_rect = [inner_margin, inner_margin, size - inner_margin, size - inner_margin]
    draw.rectangle(inner_rect, outline='#4CAF50', width=size//128)
    
    # Draw left arc (blue circle)
    arc_size = icon_size // 3
    left_arc_pos = [icon_margin, icon_margin + icon_size//4, 
                   icon_margin + arc_size, icon_margin + icon_size//4 + arc_size]
    draw.ellipse(left_arc_pos, fill='#2196F3')
    
    # Draw right arc (green circle)
    right_arc_pos = [size - icon_margin - arc_size, icon_margin + icon_size//4,
                    size - icon_margin, icon_margin + icon_size//4 + arc_size]
    draw.ellipse(right_arc_pos, fill='#26A69A')
    
    # Draw center connecting line
    line_width = size // 64
    line_height = size // 32
    line_x = (size - line_width) // 2
    line_y = icon_margin + icon_size // 2
    draw.rectangle([line_x, line_y, line_x + line_width, line_y + line_height], 
                  fill='#636E72')
    
    # Add text
    try:
        # Try to use a system font
        font_size = size // 12
        font = ImageFont.truetype("/System/Library/Fonts/Arial.ttf", font_size)
    except:
        # Fallback to default font
        font = ImageFont.load_default()
    
    # Draw "Business" text
    business_text = "Business"
    text_width = draw.textlength(business_text, font=font)
    business_x = (size - text_width) // 2
    business_y = icon_margin + icon_size + size // 16
    draw.text((business_x, business_y), business_text, fill='#2D3436', font=font)
    
    # Draw "Code" text
    code_text = "Code"
    text_width = draw.textlength(code_text, font=font)
    code_x = (size - text_width) // 2
    code_y = business_y + font_size + size // 32
    draw.text((code_x, code_y), code_text, fill='#2196F3', font=font)
    
    return img

def main():
    # Create assets directory if it doesn't exist
    os.makedirs('assets/logo', exist_ok=True)
    
    # Generate different sizes
    sizes = [512, 256, 128, 64]
    
    for size in sizes:
        img = create_business_code_logo(size)
        filename = f'assets/logo/business_code_logo_{size}.png'
        img.save(filename)
        print(f'Generated: {filename}')
    
    # Also create the main logo file for flutter_native_splash
    img = create_business_code_logo(512)
    img.save('assets/logo/business_code_logo.png')
    print('Generated: assets/logo/business_code_logo.png')

if __name__ == '__main__':
    main()
