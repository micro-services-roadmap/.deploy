package {{.PkgName}}

import (
	"net/http"
	"github.com/micro-services-roadmap/oneid-core/model"

	"github.com/zeromicro/go-zero/rest/httpx"
	{{.ImportPackages}}
)

func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
            httpx.OkJsonCtx(r.Context(), w, model.FailWithError(err))
  			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(r.Context(), svcCtx)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})

		if err != nil {
            if v, ok := err.(*model.CodeError); ok {
                httpx.OkJsonCtx(r.Context(), w, model.Res(v.Code, nil, v.Msg))
            } else {
                httpx.OkJsonCtx(r.Context(), w, model.FailWithError(err))
            }
        } else {
            httpx.OkJsonCtx(r.Context(), w, {{if .HasResp}}model.OkWithData(resp){{else}}model.Ok(){{end}})
        }
	}
}
