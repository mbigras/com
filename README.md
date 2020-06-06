# com

> Com is a wrapper around other command-line utilities.

## Usage

```
com command [arg, ...]
```

## Examples

```
com ansible-playbook ping.yml
com vault kv list secret
```

## Building

```
git clone github.com/mbigras/com
cd com
make build
```

## Dependencies

This project uses Docker.
For instructions on how to install docker on your system check out:

https://docs.docker.com/get-docker/
