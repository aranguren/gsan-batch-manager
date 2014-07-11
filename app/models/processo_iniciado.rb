class ProcessoIniciado < ActiveRecord::Base
  self.table_name='batch.processo_iniciado'
  self.primary_key='proi_id'

  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usur_id'
  belongs_to :processo, class_name: 'Processo', foreign_key: 'proc_id'
  belongs_to :processo_pai, class_name: 'ProcessoIniciado', foreign_key: 'proi_id'
  belongs_to :situacao, class_name: 'ProcessoSituacao', foreign_key: 'prst_id'

  alias_attribute 'id', 'proi_id'
  alias_attribute 'precedente', 'proi_idprecedente'
  alias_attribute 'agendamento', 'proi_tmagendamento'
  alias_attribute 'hora_inicio', 'proi_tminicio'
  alias_attribute 'hora_termino', 'proi_tmtermino'
  alias_attribute 'hora_comando', 'proi_tmcomando'
  alias_attribute 'ultima_alteracao', 'proi_tmultimaalteracao'
  alias_attribute 'grupo', 'proi_nngrupo'

  paginates_per 20

  def nome
    processo.nome
  end

  class << self
    def em_espera
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'EM ESPERA'")
    end

    def em_processamento
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'EM PROCESSAMENTO'")
    end

    def concluido
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'CONCLUIDO'")
    end

    def agendado
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'AGENDADO'")
    end

    def aguard_autorizacao
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'AGUARD. AUTORIZACAO'")
    end

    def execucao_cancelada
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'EXECUCAO CANCELADA'")
    end

    def concluido_com_erro
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'CONCLUIDO COM ERRO'")
    end

    def inicio_a_comandar
      joins(:situacao).where("processo_situacao.prst_dsprocessosituacao = 'INICIO_A_COMANDAR'")
    end
  end
end