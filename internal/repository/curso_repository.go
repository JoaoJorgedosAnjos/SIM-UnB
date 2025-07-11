package repository

import (
	"context"
	"fmt"

	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/domain"
	"github.com/jackc/pgx/v5"
)

type CursoRepository struct {
	db *pgx.Conn
}

func NewCursoRepository(db *pgx.Conn) *CursoRepository {
	return &CursoRepository{db: db}
}

func (r *CursoRepository) FindAll() ([]domain.Curso, error) {
	query := `
		SELECT c.cod_curso, c.nome_curso, c.cod_departamento, c.nivel_curso, d.nome_departamento
		FROM curso c
		JOIN departamento d ON c.cod_departamento = d.cod_departamento
		ORDER BY c.nome_curso
	`
	rows, err := r.db.Query(context.Background(), query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var cursos []domain.Curso
	for rows.Next() {
		var curso domain.Curso
		if err := rows.Scan(&curso.CodCurso, &curso.NomeCurso, &curso.CodDepartamento, &curso.NivelCurso, &curso.NomeDepartamento); err != nil {
			return nil, err
		}
		cursos = append(cursos, curso)
	}
	return cursos, nil
}

func (r *CursoRepository) FindByID(codCurso int) (domain.Curso, error) {
	query := `
		SELECT c.cod_curso, c.nome_curso, c.cod_departamento, c.nivel_curso, d.nome_departamento
		FROM curso c
		JOIN departamento d ON c.cod_departamento = d.cod_departamento
		WHERE c.cod_curso = $1
	`
	var curso domain.Curso
	err := r.db.QueryRow(context.Background(), query, codCurso).Scan(
		&curso.CodCurso,
		&curso.NomeCurso,
		&curso.CodDepartamento,
		&curso.NivelCurso,
		&curso.NomeDepartamento,
	)
	if err != nil {
		return domain.Curso{}, err
	}
	return curso, nil
}

func (r *CursoRepository) Create(curso domain.Curso) (domain.Curso, error) {
	query := `
		INSERT INTO curso (nome_curso, cod_departamento, nivel_curso)
		VALUES ($1, $2, $3)
		RETURNING cod_curso, nome_curso, cod_departamento, nivel_curso
	`
	var novoCurso domain.Curso
	err := r.db.QueryRow(context.Background(), query,
		curso.NomeCurso,
		curso.CodDepartamento,
		curso.NivelCurso,
	).Scan(&novoCurso.CodCurso, &novoCurso.NomeCurso, &novoCurso.CodDepartamento, &novoCurso.NivelCurso)

	if err != nil {
		return domain.Curso{}, err
	}

	return novoCurso, nil
}

func (r *CursoRepository) Update(codCurso int, curso domain.Curso) (domain.Curso, error) {
	query := `
		UPDATE curso
		SET nome_curso = $1, cod_departamento = $2, nivel_curso = $3
		WHERE cod_curso = $4
		RETURNING cod_curso, nome_curso, cod_departamento, nivel_curso
	`
	var cursoAtualizado domain.Curso
	err := r.db.QueryRow(context.Background(), query,
		curso.NomeCurso,
		curso.CodDepartamento,
		curso.NivelCurso,
		codCurso,
	).Scan(&cursoAtualizado.CodCurso, &cursoAtualizado.NomeCurso, &cursoAtualizado.CodDepartamento, &cursoAtualizado.NivelCurso)

	if err != nil {
		return domain.Curso{}, err
	}
	return cursoAtualizado, nil
}

func (r *CursoRepository) Delete(codCurso int) error {
	query := "DELETE FROM curso WHERE cod_curso = $1"

	res, err := r.db.Exec(context.Background(), query, codCurso)
	if err != nil {
		return err
	}

	if res.RowsAffected() == 0 {
		return fmt.Errorf("nenhum curso encontrado com o código %d", codCurso)
	}

	return nil
}
