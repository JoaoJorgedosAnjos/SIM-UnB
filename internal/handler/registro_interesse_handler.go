package handler

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/domain"
	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/repository"
	"github.com/go-chi/chi/v5"
)

type RegistroInteresseHandler struct {
	repo *repository.RegistroInteresseRepository
}

func NewRegistroInteresseHandler(repo *repository.RegistroInteresseRepository) *RegistroInteresseHandler {
	return &RegistroInteresseHandler{repo: repo}
}

// @Summary      Lista todos os registros de interesse
// @Description  Retorna uma lista de todos os interesses registrados
// @Tags         Interesses
// @Accept       json
// @Produce      json
// @Success      200  {array}   domain.RegistroInteresse
// @Failure      500  {object}  map[string]string
// @Router       /interesses [get]
func (h *RegistroInteresseHandler) GetAll(w http.ResponseWriter, r *http.Request) {
	registros, err := h.repo.FindAll()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(registros)
}

// @Summary      Busca um registro de interesse pelo ID
// @Description  Retorna os detalhes de um único registro de interesse
// @Tags         Interesses
// @Accept       json
// @Produce      json
// @Param        id   path      int  true  "ID do Registro de Interesse"
// @Success      200  {object}  domain.RegistroInteresse
// @Failure      404  {object}  map[string]string
// @Router       /interesses/{id} [get]
func (h *RegistroInteresseHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	id, _ := strconv.Atoi(chi.URLParam(r, "id"))
	registro, err := h.repo.FindByID(id)
	if err != nil {
		http.Error(w, "Registro não encontrado", http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(registro)
}

// @Summary      Cria um novo registro de interesse
// @Description  Registra o interesse de um aluno em uma turma
// @Tags         Interesses
// @Accept       json
// @Produce      json
// @Param        interesse  body      domain.RegistroInteresse  true  "Dados do Interesse"
// @Success      201        {object}  domain.RegistroInteresse
// @Failure      400        {object}  map[string]string
// @Failure      500        {object}  map[string]string
// @Router       /interesses [post]
func (h *RegistroInteresseHandler) Create(w http.ResponseWriter, r *http.Request) {
	var registro domain.RegistroInteresse
	if err := json.NewDecoder(r.Body).Decode(&registro); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	novoRegistro, err := h.repo.Create(registro)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(novoRegistro)
}

// @Summary      Atualiza um registro de interesse
// @Description  Atualiza a prioridade ou status de um registro de interesse
// @Tags         Interesses
// @Accept       json
// @Produce      json
// @Param        id         path      int                       true  "ID do Registro de Interesse"
// @Param        interesse  body      domain.RegistroInteresse  true  "Dados para Atualizar"
// @Success      200        {object}  domain.RegistroInteresse
// @Failure      400        {object}  map[string]string
// @Failure      500        {object}  map[string]string
// @Router       /interesses/{id} [put]
func (h *RegistroInteresseHandler) Update(w http.ResponseWriter, r *http.Request) {
	id, _ := strconv.Atoi(chi.URLParam(r, "id"))
	var registro domain.RegistroInteresse
	if err := json.NewDecoder(r.Body).Decode(&registro); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	registroAtualizado, err := h.repo.Update(id, registro)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(registroAtualizado)
}

// @Summary      Apaga um registro de interesse
// @Description  Remove o interesse de um aluno em uma turma
// @Tags         Interesses
// @Accept       json
// @Produce      json
// @Param        id   path      int  true  "ID do Registro de Interesse"
// @Success      204  {object}  nil
// @Failure      500  {object}  map[string]string
// @Router       /interesses/{id} [delete]
func (h *RegistroInteresseHandler) Delete(w http.ResponseWriter, r *http.Request) {
	id, _ := strconv.Atoi(chi.URLParam(r, "id"))
	if err := h.repo.Delete(id); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}