package domain

type Curso struct {
	CodCurso         int    `json:"cod_curso"`
	NomeCurso        string `json:"nome_curso"`
	CodDepartamento  int    `json:"cod_departamento"`
	NivelCurso       string `json:"nivel_curso"`
	NomeDepartamento string `json:"nome_departamento,omitempty"`
}