package repository

import (
	"context"
	"fmt"
	"log"

	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/domain"
	"github.com/jackc/pgx/v5"
)

type AlunoRepository struct {
	db *pgx.Conn
}

func NewAlunoRepository(db *pgx.Conn) *AlunoRepository {
	return &AlunoRepository{db: db}
}

func (r *AlunoRepository) FindAll() ([]domain.Aluno, error) {
	query := "SELECT matricula, cpf, nome_completo, data_nascimento, nacionalidade, semestre_ingresso, email_pessoal, email_institucional, senha, cod_curso, foto FROM aluno"

	rows, err := r.db.Query(context.Background(), query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var alunos []domain.Aluno
	for rows.Next() {
		var aluno domain.Aluno
		err := rows.Scan(
			&aluno.Matricula,
			&aluno.CPF,
			&aluno.NomeCompleto,
			&aluno.DataNascimento,
			&aluno.Nacionalidade,
			&aluno.SemestreIngresso,
			&aluno.EmailPessoal,
			&aluno.EmailInstitucional,
			&aluno.Senha,
			&aluno.CodCurso,
			&aluno.Foto,
		)
		if err != nil {
			log.Printf("Erro ao escanear a linha do aluno: %v", err)
			continue
		}
		alunos = append(alunos, aluno)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return alunos, nil
}

func (r *AlunoRepository) FindByID(matricula string) (domain.Aluno, error) {
	query := "SELECT matricula, cpf, nome_completo, data_nascimento, nacionalidade, semestre_ingresso, email_pessoal, email_institucional, senha, cod_curso, foto FROM aluno WHERE matricula = $1"

	var aluno domain.Aluno
	err := r.db.QueryRow(context.Background(), query, matricula).Scan(
		&aluno.Matricula,
		&aluno.CPF,
		&aluno.NomeCompleto,
		&aluno.DataNascimento,
		&aluno.Nacionalidade,
		&aluno.SemestreIngresso,
		&aluno.EmailPessoal,
		&aluno.EmailInstitucional,
		&aluno.Senha,
		&aluno.CodCurso,
		&aluno.Foto,
	)
	if err != nil {
		return domain.Aluno{}, err
	}
	return aluno, nil
}

func (r *AlunoRepository) Create(aluno domain.Aluno) (domain.Aluno, error) {
	query := `INSERT INTO aluno (matricula, cpf, nome_completo, data_nascimento, nacionalidade, semestre_ingresso, email_pessoal, email_institucional, senha, cod_curso)
              VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
              RETURNING matricula, cpf, nome_completo, data_nascimento, nacionalidade, semestre_ingresso, email_pessoal, email_institucional, senha, cod_curso, foto`

	var novoAluno domain.Aluno
	err := r.db.QueryRow(context.Background(), query,
		aluno.Matricula,
		aluno.CPF,
		aluno.NomeCompleto,
		aluno.DataNascimento,
		aluno.Nacionalidade,
		aluno.SemestreIngresso,
		aluno.EmailPessoal,
		aluno.EmailInstitucional,
		aluno.Senha,
		aluno.CodCurso,
	).Scan(
		&novoAluno.Matricula,
		&novoAluno.CPF,
		&novoAluno.NomeCompleto,
		&novoAluno.DataNascimento,
		&novoAluno.Nacionalidade,
		&novoAluno.SemestreIngresso,
		&novoAluno.EmailPessoal,
		&novoAluno.EmailInstitucional,
		&novoAluno.Senha,
		&novoAluno.CodCurso,
		&novoAluno.Foto,
	)

	if err != nil {
		return domain.Aluno{}, err
	}

	return novoAluno, nil
}

func (r *AlunoRepository) Update(matricula string, aluno domain.Aluno) (domain.Aluno, error) {
	query := `UPDATE aluno
              SET nome_completo = $1, data_nascimento = $2, email_pessoal = $3, email_institucional = $4, senha = $5
              WHERE matricula = $6
              RETURNING matricula, cpf, nome_completo, data_nascimento, nacionalidade, semestre_ingresso, email_pessoal, email_institucional, senha, cod_curso, foto`

	var alunoAtualizado domain.Aluno
	err := r.db.QueryRow(context.Background(), query,
		aluno.NomeCompleto,
		aluno.DataNascimento,
		aluno.EmailPessoal,
		aluno.EmailInstitucional,
		aluno.Senha,
		matricula, 
	).Scan(
		&alunoAtualizado.Matricula,
		&alunoAtualizado.CPF,
		&alunoAtualizado.NomeCompleto,
		&alunoAtualizado.DataNascimento,
		&alunoAtualizado.Nacionalidade,
		&alunoAtualizado.SemestreIngresso,
		&alunoAtualizado.EmailPessoal,
		&alunoAtualizado.EmailInstitucional,
		&alunoAtualizado.Senha,
		&alunoAtualizado.CodCurso,
		&alunoAtualizado.Foto,
	)

	if err != nil {
		return domain.Aluno{}, err
	}

	return alunoAtualizado, nil
}

func (r *AlunoRepository) Delete(matricula string) error {
	query := "DELETE FROM aluno WHERE matricula = $1"

	res, err := r.db.Exec(context.Background(), query, matricula)
	if err != nil {
		return err
	}

	if res.RowsAffected() == 0 {
		return fmt.Errorf("nenhum aluno encontrado com a matrícula %s", matricula)
	}

	return nil
}

func (r *AlunoRepository) UpdateFoto(matricula string, fotoData []byte) error {
	query := "UPDATE aluno SET foto = $1 WHERE matricula = $2"

	res, err := r.db.Exec(context.Background(), query, fotoData, matricula)
	if err != nil {
		return err
	}

	if res.RowsAffected() == 0 {
		return fmt.Errorf("nenhum aluno encontrado com a matrícula %s para atualizar a foto", matricula)
	}

	return nil
}