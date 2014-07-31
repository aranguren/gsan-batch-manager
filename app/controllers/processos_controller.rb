class ProcessosController < ApplicationController

  before_action :get_processos

  def index
  end

  def configura
  end

  def filtrar
    @processos = @processos.joins(:processo).where("processo.proc_dsprocesso LIKE ?", "%#{params[:processo]}%") unless params[:processo].blank?
    @processos = @processos.joins(:usuario).where("usuario.usur_nmusuario LIKE ?", "%#{params[:usuario]}%") unless params[:usuario].blank?
    @processos = @processos.where("processo_iniciado.proi_nngrupo = ?", params[:grupo]) unless params[:grupo].blank?
    @processos = @processos.where("processo_iniciado.proi_tminicio >= ?", params[:data_processo_inicio]) unless params[:data_processo_inicio].blank?
    @processos = @processos.where("processo_iniciado.proi_tmtermino <= ?", params[:data_processo_final]) unless params[:data_processo_final].blank?

    @total = @processos.count
    @processos.page params[:page]

    render :index
  end

  private

  def get_processos
    @filtros = params
    @filtros[:situacao] = "EM PROCESSAMENTO" if @filtros[:situacao].blank?

    @processos = ProcessoIniciado.send(@filtros[:situacao].downcase.gsub(" ", "_").gsub("\.", "")).page params[:page]
    @total = @processos.count
  end
end
