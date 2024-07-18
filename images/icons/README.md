# Icons

This folder contains the icons used in the mod.

To access the icons in-game, they are packed and loaded as a font.

## How to Generate the Font

Here is a step-by-step guide on how to generate the font using Windows:

1. Create the `font.fnt` and `font.png` files

    Make sure you have **python** installed with the packages: **pyyaml** and **pillow**.

    Get the font-maker tool: https://github.com/Legend-Master/DST-Nitro-Font-Maker

    Run the tool on this folder:
    ```sh
    python <path-to-font-maker>/main.py .
    ```

    This will generate a folder called `output` containing the files.

2. Convert PNG to TEX

    Get Handsome Matt's tools: https://github.com/handsomematt/dont-starve-tools

    Run `TEXCreator.exe`.

    Click `Add` and select the `font.png` atlas generated in step 1.

    Choose a destination folder.

    Click `Convert`.

3. Zip the files

    Grab `font.fnt` (from step 1) and `font.tex` (from step 2) and zip them into `icons.zip`.

4. Move the zip

    Move the `icons.zip` file to the [fonts](../../fonts) folder
