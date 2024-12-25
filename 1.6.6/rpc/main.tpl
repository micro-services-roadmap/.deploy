package main

import (
	"flag"
	"fmt"
	"os"

	{{.imports}}

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/service"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	"github.com/micro-services-roadmap/kit-common"
	"github.com/micro-services-roadmap/kit-common/gz"
	"github.com/micro-services-roadmap/kit-common/kg"
	"github.com/wordpress-plus/rpc-{{.serviceName}}/source/gen/dal"
)

var configFile string

func init() {
	if con := os.Getenv("config"); len(con) != 0 {
		configFile = con
	} else {
		configFile = "etc/{{.serviceName}}-staging.yaml"
	}
	fmt.Println("use config: " + configFile)

	kit.Init(configFile)
	dal.SetDefault(kg.DB)
}

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(configFile, &c)
	ctx := svc.NewServiceContext(c)

	s := zrpc.MustNewServer(c.RpcServerConf, func(grpcServer *grpc.Server) {
{{range .serviceNames}}       {{.Pkg}}.Register{{.GRPCService}}Server(grpcServer, {{.ServerPkg}}.New{{.Service}}Server(ctx))
{{end}}
		if c.Mode == service.DevMode || c.Mode == service.TestMode {
			reflection.Register(grpcServer)
		}
	})
	s.AddUnaryInterceptors(gz.LoggerInterceptor)
	defer s.Stop()

	fmt.Printf("Starting rpc server at %s...\n", c.ListenOn)
	s.Start()
}
