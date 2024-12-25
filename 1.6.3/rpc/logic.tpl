package {{.packageName}}

import (
	"context"
	"github.com/micro-services-roadmap/kit-common/util/copier"

	{{.imports}}

	"github.com/wordpress-plus/rpc-pms/source/gen/dal"
	"github.com/wordpress-plus/rpc-pms/source/gen/model"
	"github.com/zeromicro/go-zero/core/logx"
)

type {{.logicName}} struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
}

func New{{.logicName}}(ctx context.Context,svcCtx *svc.ServiceContext) *{{.logicName}} {
	return &{{.logicName}}{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
	}
}
{{.functions}}
