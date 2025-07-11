package repository

import (
	"context"
	"fmt"

	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/domain"
	"github.com/jackc/pgx/v5"
)

type RegistroInteresseRepository struct {
	db *pgx.Conn
}

func NewRegistroInteresseRepository(db *pgx.Conn) *RegistroInteresseRepository {
	return &RegistroInteresseRepository{db: db}
}

func (r *RegistroInteresseRepository) FindAll() ([]domain.RegistroInteresse, error) {
	query := "SELECT id_registro_interesse, matricula_aluno, id_turma, data_registro_interesse, status_interesse, prioridade_interesse FROM registro_interesse"
	rows, err := r.db.Query(context.Background(), query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var registros []domain.RegistroInteresse
	for rows.Next() {
		var registro domain.RegistroInteresse
		if err := rows.Scan(&registro.IDRegistroInteresse, &registro.MatriculaAluno, &registro.IDTurma, &registro.DataRegistroInteresse, &registro.StatusInteresse, &registro.PrioridadeInteresse); err != nil {
			return nil, err
		}
		registros = append(registros, registro)
	}
	return registros, nil
}

func (r *RegistroInteresseRepository) FindByID(id int) (domain.RegistroInteresse, error) {
	query := "SELECT id_registro_interesse, matricula_aluno, id_turma, data_registro_interesse, status_interesse, prioridade_interesse FROM registro_interesse WHERE id_registro_interesse = $1"
	var registro domain.RegistroInteresse
	err := r.db.QueryRow(context.Background(), query, id).Scan(&registro.IDRegistroInteresse, &registro.MatriculaAluno, &registro.IDTurma, &registro.DataRegistroInteresse, &registro.StatusInteresse, &registro.PrioridadeInteresse)
	if err != nil {
		return domain.RegistroInteresse{}, err
	}
	return registro, nil
}

func (r *RegistroInteresseRepository) Create(registro domain.RegistroInteresse) (domain.RegistroInteresse, error) {
	query := `
		INSERT INTO registro_interesse (matricula_aluno, id_turma, prioridade_interesse)
		VALUES ($1, $2, $3)
		RETURNING id_registro_interesse, matricula_aluno, id_turma, data_registro_interesse, status_interesse, prioridade_interesse
	`
	var novoRegistro domain.RegistroInteresse
	err := r.db.QueryRow(context.Background(), query, registro.MatriculaAluno, registro.IDTurma, registro.PrioridadeInteresse).Scan(
		&novoRegistro.IDRegistroInteresse, &novoRegistro.MatriculaAluno, &novoRegistro.IDTurma, &novoRegistro.DataRegistroInteresse, &novoRegistro.StatusInteresse, &novoRegistro.PrioridadeInteresse,
	)
	if err != nil {
		return domain.RegistroInteresse{}, err
	}
	return novoRegistro, nil
}

func (r *RegistroInteresseRepository) Update(id int, registro domain.RegistroInteresse) (domain.RegistroInteresse, error) {
	query := `
		UPDATE registro_interesse
		SET prioridade_interesse = $1, status_interesse = $2
		WHERE id_registro_interesse = $3
		RETURNING id_registro_interesse, matricula_aluno, id_turma, data_registro_interesse, status_interesse, prioridade_interesse
	`
	var registroAtualizado domain.RegistroInteresse
	err := r.db.QueryRow(context.Background(), query, registro.PrioridadeInteresse, registro.StatusInteresse, id).Scan(
		&registroAtualizado.IDRegistroInteresse, &registroAtualizado.MatriculaAluno, &registroAtualizado.IDTurma, &registroAtualizado.DataRegistroInteresse, &registroAtualizado.StatusInteresse, &registroAtualizado.PrioridadeInteresse,
	)
	if err != nil {
		return domain.RegistroInteresse{}, err
	}
	return registroAtualizado, nil
}

func (r *RegistroInteresseRepository) Delete(id int) error {
	query := "DELETE FROM registro_interesse WHERE id_registro_interesse = $1"
	res, err := r.db.Exec(context.Background(), query, id)
	if err != nil {
		return err
	}
	if res.RowsAffected() == 0 {
		return fmt.Errorf("nenhum registro de interesse encontrado com o ID %d", id)
	}
	return nil
}