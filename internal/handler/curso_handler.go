package handler

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/domain"
	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/repository"
	"github.com/go-chi/chi/v5"
)

type CursoHandler struct {
	repo *repository.CursoRepository
}

func NewCursoHandler(repo *repository.CursoRepository) *CursoHandler {
	return &CursoHandler{repo: repo}
}
// @Summary      Lista todos os cursos
// @Description  Retorna uma lista de todos os cursos, incluindo o nome do departamento
// @Tags         Cursos
// @Accept       json
// @Produce      json
// @Success      200  {array}   domain.Curso
// @Failure      500  {object}  map[string]string
// @Router       /cursos [get]
func (h *CursoHandler) GetAllCursos(w http.ResponseWriter, r *http.Request) {
	cursos, err := h.repo.FindAll()
	if err != nil {
		http.Error(w, "Erro ao buscar cursos: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(cursos)
}
// @Summary      Busca um curso pelo ID
// @Description  Retorna os detalhes de um único curso com base no seu ID
// @Tags         Cursos
// @Accept       json
// @Produce      json
// @Param        id   path      int  true  "ID do Curso"
// @Success      200  {object}  domain.Curso
// @Failure      400  {object}  map[string]string
// @Failure      404  {object}  map[string]string
// @Router       /cursos/{id} [get]
func (h *CursoHandler) GetCursoByID(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "ID inválido", http.StatusBadRequest)
		return
	}

	curso, err := h.repo.FindByID(id)
	if err != nil {
		http.Error(w, "Curso não encontrado: "+err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(curso)
}

// @Summary      Cria um novo curso
// @Description  Cria um novo curso com base nos dados enviados
// @Tags         Cursos
// @Accept       json
// @Produce      json
// @Param        curso  body      domain.Curso  true  "Dados do Curso para Criar"
// @Success      201    {object}  domain.Curso
// @Failure      400    {object}  map[string]string
// @Failure      500    {object}  map[string]string
// @Router       /cursos [post]
func (h *CursoHandler) CreateCurso(w http.ResponseWriter, r *http.Request) {
	var curso domain.Curso

	err := json.NewDecoder(r.Body).Decode(&curso)
	if err != nil {
		http.Error(w, "Erro ao decodificar JSON: "+err.Error(), http.StatusBadRequest)
		return
	}

	novoCurso, err := h.repo.Create(curso)
	if err != nil {
		http.Error(w, "Erro ao criar curso: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(novoCurso)
}

// @Summary      Atualiza um curso existente
// @Description  Atualiza os dados de um curso com base no seu ID
// @Tags         Cursos
// @Accept       json
// @Produce      json
// @Param        id     path      int           true  "ID do Curso"
// @Param        curso  body      domain.Curso  true  "Dados do Curso para Atualizar"
// @Success      200    {object}  domain.Curso
// @Failure      400    {object}  map[string]string
// @Failure      500    {object}  map[string]string
// @Router       /cursos/{id} [put]
func (h *CursoHandler) UpdateCurso(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "ID inválido", http.StatusBadRequest)
		return
	}

	var curso domain.Curso
	if err := json.NewDecoder(r.Body).Decode(&curso); err != nil {
		http.Error(w, "Erro ao decodificar JSON: "+err.Error(), http.StatusBadRequest)
		return
	}

	cursoAtualizado, err := h.repo.Update(id, curso)
	if err != nil {
		http.Error(w, "Erro ao atualizar curso: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(cursoAtualizado)
}

// @Summary      Apaga um curso
// @Description  Apaga um curso do banco de dados com base no seu ID
// @Tags         Cursos
// @Accept       json
// @Produce      json
// @Param        id   path      int  true  "ID do Curso"
// @Success      204  {object}  nil
// @Failure      400  {object}  map[string]string
// @Failure      500  {object}  map[string]string
// @Router       /cursos/{id} [delete]
func (h *CursoHandler) DeleteCurso(w http.ResponseWriter, r *http.Request) {
	idStr := chi.URLParam(r, "id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "ID inválido", http.StatusBadRequest)
		return
	}

	err = h.repo.Delete(id)
	if err != nil {
		http.Error(w, "Erro ao apagar curso: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}