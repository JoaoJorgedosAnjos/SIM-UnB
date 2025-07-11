package domain

import "time"

type RegistroInteresse struct {
	IDRegistroInteresse    int       `json:"id_registro_interesse"`
	MatriculaAluno         string    `json:"matricula_aluno"`
	IDTurma                int       `json:"id_turma"`
	DataRegistroInteresse  time.Time `json:"data_registro_interesse"`
	StatusInteresse        string    `json:"status_interesse"`
	PrioridadeInteresse    int       `json:"prioridade_interesse"`
}