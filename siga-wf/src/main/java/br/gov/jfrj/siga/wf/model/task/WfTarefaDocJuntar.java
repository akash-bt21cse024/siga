package br.gov.jfrj.siga.wf.model.task;

import com.crivano.jflow.Engine;
import com.crivano.jflow.Handler;
import com.crivano.jflow.Task;
import com.crivano.jflow.TaskResult;
import com.crivano.jflow.model.enm.TaskResultKind;
import br.gov.jfrj.siga.Service;
import br.gov.jfrj.siga.base.util.Utils;
import br.gov.jfrj.siga.dp.DpLotacao;
import br.gov.jfrj.siga.dp.DpPessoa;
import br.gov.jfrj.siga.parser.SiglaParser;
import br.gov.jfrj.siga.wf.model.WfDefinicaoDeTarefa;
import br.gov.jfrj.siga.wf.model.WfProcedimento;
import br.gov.jfrj.siga.wf.util.WfResp;
import br.gov.jfrj.siga.wf.model.enm.WfTipoDeResponsavel;

public class WfTarefaDocJuntar implements Task<WfDefinicaoDeTarefa, WfProcedimento> {	
	/**
	 * Esse método é responsável por Juntar 2 documentos recebidos na tarefa Juntar
	 * Junta o documento principal(Filho) no documento informado pelo usuário(Pai).
	 * O documento pai é fixo (número preenchido na elaboração do diagrama)
	 *
	 * @param td Tarefa.
	 * @param pi Procedimento.
	 * @return TaskResult Resultado da execução da tarefa.
	 */
	@Override
	public TaskResult execute(
			WfDefinicaoDeTarefa td, 
			WfProcedimento pi, 
			Engine engine) throws Exception {
		
		// TODO: Adicionar campo doc pai fixo ou variável no front-end como foi feito pro outro campo
		
		// TODO: Armazenar seleção do usuario no campo param ou param2 como foi feito no param3
			// TODO: Se essa solução não funcionar, criar novo campo no banco de dados exclusivo para esse valor
		
		String formCampoDocPaiFixoOuVariavel = "FIXO";
		
		// TODO: Receber valor do campo doc pai fixo ou variável e sakvar na variavel formCampoDocPaiFixoOuVariavel
		// formCampoDocPaiFixoOuVariavel = informação recebida do frontend
		assert formCampoDocPaiFixoOuVariavel == "FIXO" || formCampoDocPaiFixoOuVariavel == "VARIAVEL";
		
		// TODO: if documento pai é variavel, executa:
		
		// TODO: Código específico para documento pai variável
		
		assert formCampoDocPaiFixoOuVariavel != null;
		assert isDocPaiVariavel(formCampoDocPaiFixoOuVariavel) == null;
		assert docPaiVariavel() == null;
		
		WfTipoDeResponsavel wfTipoDeResponsavel = WfTipoDeResponsavel.PRINCIPAL_LOTA_CADASTRANTE;
		td.setTipoDeResponsavel(wfTipoDeResponsavel);
		String siglaDestino = "";
		String siglaCadastrante = "";
		String codigoDocumentoPai = "";
		String codigoDocumentoPrincipal = "";
		String codigoDocumentoFilho = "";
		Boolean documentoPaiSeraONovoPrincipal = false;
		
		documentoPaiSeraONovoPrincipal = isDocPaiNovoPrincipal(td, pi, engine);
		assert documentoPaiSeraONovoPrincipal != null;
		
		codigoDocumentoPai = recebeDocumentoPaiDaEntradaDoUsuario(td, pi, engine);
		assert codigoDocumentoPai != null && codigoDocumentoPai != "";
		
		codigoDocumentoPrincipal = pi.getPrincipal();
		assert codigoDocumentoPrincipal != null;
		
		codigoDocumentoFilho = codigoDocumentoPrincipal;
		assert codigoDocumentoFilho != null && codigoDocumentoFilho != "";
		
		if (documentoPaiSeraONovoPrincipal) {
			pi.setPrincipal(codigoDocumentoPai);
			assert pi.getPrincipal() == codigoDocumentoPai;
		}
		
		if (!Utils.empty(codigoDocumentoPrincipal)) { 
			WfResp responsavel = pi.calcResponsible(td);
			siglaDestino = geraSiglaDoResponsavel(responsavel);
			siglaCadastrante = geraSiglaDoResponsavel(responsavel);
			
			Service.getExService().juntar(codigoDocumentoFilho, 
					codigoDocumentoPai, 
					siglaDestino, 
					siglaCadastrante);
		}
		return new TaskResult(TaskResultKind.DONE, null, null, null, null);
	}
	
	private String isDocPaiVariavel(String formCampoDocPaiFixoOuVariavel) {
		// TODO: Como funciona a passagem de variável de uma tarefa anterior para a nova através do workflow
			//TODO: analizar anotações da explicação do Renato
			//TODO: tirar dúvidas sobre como funciona
		
		// TODO: Verificar se usuário selecionou fixo ou variável
		// TODO: Se for variável, execute o código abaixo
		// TODO: Desenvolver código do Doc pai variável
		
		String saida = docPaiVariavel();
		return saida;
	}
	
	private String docPaiVariavel() {
		// TODO: Desenvolver código do Doc pai variável
		return null;
	}
	
	public Boolean isDocPaiNovoPrincipal(WfDefinicaoDeTarefa td, 
			WfProcedimento pi, 
			Engine engine) {
		
		String valorFormCampoDocumentoPaiSeraONovoPrincipal = null;
		
	    try {
	    	Handler handler = engine.getHandler();
	    	String param3 = td.getParam3();
	    	valorFormCampoDocumentoPaiSeraONovoPrincipal = handler.evalTemplate(pi, param3);	
	    } catch (NullPointerException npe) {
	        System.err.println("Erro: Um valor nulo foi encontrado.");
	    } catch (Exception e) {
	        System.err.println("Erro: " + e.getMessage());
	    }
	    
	    if (valorFormCampoDocumentoPaiSeraONovoPrincipal.equals("SIM")) {
			return true;
		}
		return false;
	}
	
	private String geraSiglaDoResponsavel(WfResp destino) {
		String siglaDestino = "";
		if (destino != null) { 
			DpPessoa pessoa = destino.getPessoa();
			DpLotacao lotacao = destino.getLotacao();
			try {
			    siglaDestino = SiglaParser.makeSigla(pessoa, lotacao);
			} catch (NullPointerException npe) {
				siglaDestino = "";
				}
			}
		return siglaDestino;
	}
	
	private String recebeDocumentoPaiDaEntradaDoUsuario(WfDefinicaoDeTarefa td, 
			WfProcedimento pi, 
			Engine engine) {
	    try {
	        return engine.getHandler().evalTemplate(pi, td.getSubject());
	    } catch (NullPointerException npe) {
	        System.err.println("Erro: Um valor nulo foi encontrado.");
	        return null;
	    } catch (Exception e) {
	        System.err.println("Erro ao avaliar o template: " + e.getMessage());
	        return null;
	    }
	}

}
