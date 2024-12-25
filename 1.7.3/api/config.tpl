package config

import {{.authImport}}

var C Config

type Config struct {
	rest.RestConf
	{{.auth}}
	{{.jwtTrans}}
}
