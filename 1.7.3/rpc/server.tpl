{{.head}}

package server

import (
	{{if .notStream}}"context"{{end}}

	"github.com/zeromicro/go-zero/core/logx"
	"google.golang.org/grpc/metadata"

	{{.imports}}
)

type {{.server}}Server struct {
	svcCtx *svc.ServiceContext
	{{.unimplementedServer}}
}

func New{{.server}}Server(svcCtx *svc.ServiceContext) *{{.server}}Server {
	return &{{.server}}Server{
		svcCtx: svcCtx,
	}
}

{{.funcs}}
