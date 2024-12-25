
{{if .hasComment}}{{.comment}}{{end}}
func (s *{{.server}}Server) {{.method}} ({{if .notStream}}ctx context.Context,{{if .hasReq}} in {{.request}}{{end}}{{else}}{{if .hasReq}} in {{.request}},{{end}}stream {{.streamBody}}{{end}}) ({{if .notStream}}{{.response}},{{end}}error) {
    md, ok := metadata.FromIncomingContext(ctx)
    if !ok {
        logx.WithContext(ctx).Errorf("failed to get metadata from context")
    }

	l := {{.logicPkg}}.New{{.logicName}}({{if .notStream}}ctx,{{else}}stream.Context(),{{end}}s.svcCtx, md)
	return l.{{.method}}({{if .hasReq}}in{{if .stream}} ,stream{{end}}{{else}}{{if .stream}}stream{{end}}{{end}})
}
