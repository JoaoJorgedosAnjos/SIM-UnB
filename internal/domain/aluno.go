package domain

import "time"

type Aluno struct {
	Matricula          string    `json:"matricula"`
	CPF                string    `json:"cpf"`
	NomeCompleto       string    `json:"nome_completo"`
	DataNascimento     time.Time `json:"data_nascimento"`
	Nacionalidade      string    `json:"nacionalidade"`
	SemestreIngresso   string    `json:"semestre_ingresso"`
	EmailPessoal       string    `json:"email_pessoal"`
	EmailInstitucional string    `json:"email_institucional"`
	Senha              string    `json:"-"`
	CodCurso           int       `json:"cod_curso"`
	Foto               []byte    `json:"-"`
}

type AlunoEstrangeiro struct {
	Matricula    string `json:"matricula"`
	Passaporte   string `json:"passaporte"`
	Visto        string `json:"visto"`
	PaisOrigem   string `json:"pais_origem"`
}