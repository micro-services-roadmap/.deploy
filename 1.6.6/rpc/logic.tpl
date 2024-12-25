package {{.packageName}}

import (
	"context"

	{{.imports}}

	"github.com/zeromicro/go-zero/core/logx"
    "google.golang.org/grpc/metadata"
)

type {{.logicName}} struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
	metadata.MD
}

func New{{.logicName}}(ctx context.Context,svcCtx *svc.ServiceContext,md metadata.MD) *{{.logicName}} {
	return &{{.logicName}}{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		MD:     md,
	}
}
{{.functions}}
