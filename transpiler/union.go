package transpiler

import (
	"bytes"
	"fmt"
	"html/template"
	"strings"

	goast "go/ast"
	"go/format"
	"go/parser"
	"go/token"

	"github.com/Konstantin8105/c4go/ast"
	"github.com/Konstantin8105/c4go/program"
)

func transpileUnion(name string, size int, fields []*goast.Field) (
	_ []goast.Decl, err error) {

	defer func() {
		if err != nil {
			err = fmt.Errorf("cannot transpileUnion : err = %v", err)
			if strings.Contains(err.Error(), "\n") {
				err = fmt.Errorf("%v", strings.Replace(err.Error(), "\n", "||", -1))
			}
		}
	}()

	type field struct {
		Name      string
		TypeField string
	}

	type union struct {
		Name   string
		Size   int
		Fields []field
	}

	src := `package main

import(
	"unsafe"
	"reflect"
)

type {{ .Name }} struct{
	memory unsafe.Pointer
}

func (unionVar * {{ .Name }}) copy() ( {{ .Name }}){
	var buffer [{{ .Size }}]byte
	for i := range buffer{
		buffer[i] = (*((*[{{ .Size }}]byte)(unionVar.memory)))[i]
	}
	var newUnion {{ .Name }}
	newUnion.memory = unsafe.Pointer(&buffer)
	return newUnion
}

{{ range .Fields }}
func (unionVar * {{ $.Name }}) {{ .Name }}() (*{{ .TypeField }}){
	if unionVar.memory == nil{
		var buffer [{{ $.Size }}]byte
		unionVar.memory = unsafe.Pointer(&buffer)
	}
	return (*{{ .TypeField }})(unionVar.memory)
}
{{ end }}
`
	// Generate structure of union
	var un union
	defer func() {
		if err != nil {
			err = fmt.Errorf("%v. Details of union: %#v", err, un)
		}
	}()
	un.Name = name
	un.Size = size
	for i := range fields {
		var f field
		f.Name = fields[i].Names[0].Name

		var buf bytes.Buffer
		err = format.Node(&buf, token.NewFileSet(), fields[i].Type)
		if err != nil {
			err = fmt.Errorf("cannot parse type '%s' : %v", fields[i].Type, err)
			return
		}
		f.TypeField = buf.String()

		if f.TypeField == "" {
			goast.Print(token.NewFileSet(), fields[i].Type)
			f.TypeField = "interface{}"
		}

		un.Fields = append(un.Fields, f)
	}

	tmpl := template.Must(template.New("").Parse(src))
	var source bytes.Buffer
	err = tmpl.Execute(&source, un)
	if err != nil {
		err = fmt.Errorf("cannot execute template \"%s\" for data %v : %v",
			source.String(), un, err)
		return
	}

	// Create the AST by parsing src.
	fset := token.NewFileSet() // positions are relative to fset
	f, err := parser.ParseFile(fset, "", source.String(), 0)
	if err != nil {
		err = fmt.Errorf("cannot parse source \"%s\" : %v",
			source.String(), err)
		return
	}

	return f.Decls[1:], nil
}

func isUnionMemberExpr(p *program.Program, n *ast.MemberExpr) (IsUnion bool) {
	if len(n.Children()) > 0 {
		_, t, _, _, _ := transpileToExpr(n.Children()[0], p, false)
		if p.IsUnion(t) {
			IsUnion = true
		}
	}
	return
}
