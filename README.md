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
