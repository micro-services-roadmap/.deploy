package {{.PkgName}}

import (
	"net/http"
	"github.com/kongmsr/oneid-core/modelo"
    "github.com/micro-services-roadmap/kit-common/gz"
    "github.com/micro-services-roadmap/kit-common/errorx"

	"github.com/zeromicro/go-zero/rest/httpx"
	{{.ImportPackages}}
)

func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
            httpx.WriteJsonCtx(r.Context(), w, http.StatusBadRequest, modelo.Res(999_999, nil, err.Error()))
  			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(gz.ConvertHeaderMD(r), svcCtx, r)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})

		if err != nil {
		    l.Logger.Errorf("Handler error: ", err)
			err = errorx.GrpcError(err)
            if v, ok := err.(*modelo.CodeError); ok {
                httpx.WriteJsonCtx(r.Context(), w, http.StatusBadRequest, modelo.Res(v.Code, nil, v.Error()))
            } else {
                httpx.WriteJsonCtx(r.Context(), w, http.StatusBadRequest, modelo.Res(888_888, nil, err.Error()))
            }
        } else {
            httpx.OkJsonCtx(r.Context(), w, {{if .HasResp}}resp{{else}}nil{{end}})
        }
	}
}
