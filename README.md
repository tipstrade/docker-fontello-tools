# docker-fontello-tools
A docker image that provides automation for the [Fontello API](https://github.com/fontello/fontello#developers-api).

## Usage

The docker container needs to be passed a `rw` volume into which the session, configuration, etc can be stored. By default this is in `/fontello`.
If being used with source control, it's advisable to add a `.gitignore` file to the folder that ignores the `.fontello` session state file.
```bash
mkdir -p ./fontello
```

#### Start a new session
If a `config.json` file doesn't exist in the `fontello` directory, then one will be created.
```bash
docker run --rm -v $(pwd)/fontello/:/fontello/:rw oobayly/fontello-tools:latest start
```

#### Download font
This will download the `fontello-xxxxxxxx.zip` into the `fontello` directory, as well as extracting the `config.json` file.
```bash
docker run --rm -v $(pwd)/fontello/:/fontello/:rw oobayly/fontello-tools:latest download
```
You can also add optional parameters specifying which items to extract. For example, this will also extact all the fonts in the `font` directory, as well as just the `fontello.css` file.
```bash
docker run --rm -v $(pwd)/fontello/:/fontello/:rw oobayly/fontello-tools:latest download font css/fontello.css
```

## Notes
If using relative paths the shell expansion is different for Windows:
CMD
```cmd
docker run --rm  -v %CD%/fontello/:/fontello/:rw oobayly/fontello-tools:latest start
```
Poweershell
```ps
docker run --rm  -v "$(PWD)/fontello/:/fontello/:rw" oobayly/fontello-tools:latest start
```

## Automating with NPM scripts
Further automation can be done using scripts in `package.json`
- start script will upload and output the session link
- download script will download and extract the required items
- postdownload script can be used to copy the extracted items to the required location
  - copy-fonts - copies the font files into a webapp
  - copy-font-css - uses sed to replace the relative paths in the css and output to the webapp styles
```json
{
  "scripts": {
    "fontello-start": "docker run --rm -v \"%CD%/fontello/:/fontello/:rw\" oobayly/fontello-tools:latest start",
    "fontello-download": "docker run --rm -v \"%CD%/fontello/:/fontello/:rw\" oobayly/fontello-tools:latest download font css/fontello.css",
    "postfontello-download": "npm run copy-fonts && npm run copy-font-css",
    "copy-fonts": "shx cp -R fontello/font/* ../website/public/fonts/",
    "copy-font-css": "shx sed \"s/..\\/font/\\/fonts/\" fontello/css/fontello.css > ../website/src/styles/_fontello.scss"
  },
  "devDependencies": {
    "shx": "^0.4.0"
  }
}
```
