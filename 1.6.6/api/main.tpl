package main

import (
	"flag"
	"fmt"
	"github.com/wordpress-plus/api-{{.serviceName}}/doc/swagger"
	"github.com/wordpress-plus/api-{{.serviceName}}/internal/middleware/gmw"
	"os"

	{{.importPackages}}
)

var configFile string

func init() {
	if con := os.Getenv("config"); len(con) != 0 {
		configFile = con
	} else {
		configFile = "etc/{{.serviceName}}-api-local.yaml"
	}
	fmt.Println("use config: " + configFile)

	conf.MustLoad(configFile, &config.C)
	config.ConvertSecret(config.C.PaypalWebhook)
}


func main() {
	flag.Parse()

	server := rest.MustNewServer(config.C.RestConf)
	defer server.Stop()

	svc.SvcCtx = svc.NewServiceContext(config.C)

	// mw: logger
	// server.Use(gmw.NewAddLogMiddleware(ctx).Handle)
	server.Use(gmw.NewAuthMiddleware(svc.SvcCtx).Handle)
	//server.Use(gmw.NewRecordOpsMiddleware(svc.SvcCtx).Handle)

	handler.RegisterHandlers(server, svc.SvcCtx)
	swagger.RegisterSwagger(config.C.Mode, server)

	fmt.Printf("Starting server at %s:%d...\n", config.C.Host, config.C.Port)
	server.Start()
}
