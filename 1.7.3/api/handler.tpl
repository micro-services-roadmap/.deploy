package {{.PkgName}}

import (
	"net/http"
	"github.com/micro-services-roadmap/kit-common/errorx"
	"github.com/kongmsr/oneid-core/modelo"
    "github.com/micro-services-roadmap/kit-common/gz"

	"github.com/zeromicro/go-zero/rest/httpx"
	{{.ImportPackages}}
)

func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
            httpx.OkJsonCtx(r.Context(), w, modelo.FailWithError(err))
  			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(gz.ConvertHeaderMD(r), svcCtx, r)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})

		if err != nil {
		    l.Logger.Errorf("Handler error: ", err)
			err = errorx.GrpcError(err)
            if v, ok := err.(*modelo.CodeError); ok {
                httpx.OkJsonCtx(r.Context(), w, modelo.Res(v.Code, nil, v.Msg))
            } else {
                httpx.OkJsonCtx(r.Context(), w, modelo.FailWithError(err))
            }
        } else {
            httpx.OkJsonCtx(r.Context(), w, {{if .HasResp}}modelo.OkWithData(resp){{else}}modelo.Ok(){{end}})
        }
	}
}
