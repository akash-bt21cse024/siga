<%@ page language="java" contentType="text/html; charset=UTF-8"
	buffer="64kb"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://localhost/jeetags" prefix="siga"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<siga:pagina titulo="Lista Orgão Usuário">
<script type="text/javascript" language="Javascript1.1">
function sbmt(offset) {
	if (offset == null) {
		offset = 0;
	}
	frm.elements["paramoffset"].value = offset;
	frm.elements["p.offset"].value = offset;
	frm.submit();
}

function submitPost(url) {
	var frm = document.getElementById('frm');
	frm.method = "POST";
	frm.action = url;
	frm.submit();
}

function inativar(url, orgao, qtdeUsuario, qtdeLotacao) {
	if(qtdeUsuario == "0" && qtdeLotacao == "0") {
		submitPost(url);
	} else {
		sigaModal.enviarHTMLEAbrir('confirmacaoModal', 'Órgão: ' +orgao+ '<br>Possui <fmt:message key="usuario.lotacao"/> e/ou Usuário ativo. A ação solicitada não será realizada');
	}
}
</script>
<form name="frm" id="frm" action="listar" class="form" method="GET">
	<input type="hidden" name="paramoffset" value="0" />
	<input type="hidden" name="p.offset" value="0" />
	<div class="container-fluid">
		<div class="card bg-light mb-3" >		
			<div class="card-header"><h5>Cadastro de &Oacute;rg&atilde;o</h5></div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-6">
							<div class="form-group">
								<label>Nome</label>
								<input type="text" id="nome" name="nome" value="${nome}" maxlength="100" size="30" class="form-control"/>
							</div>						
						</div>
					</div>
				
					<div class="row">
						<div class="col-sm-6">
							<input type="submit" value="Pesquisar" class="btn btn-primary"/>
						</div>
					</div>
				</div>
			</div>
			
			<!-- main content -->
			<h5>&Oacute;rg&atilde;os cadastrados</h5>
				<table border="0" class="table table-sm table-striped">
					<thead class="${thead_color}">
						<tr>
							<th class="text-left w-10">ID</th>
							<th class="text-left w-60">Nome</th>
							<th class="text-center w-10">Sigla</th>
							<th class="text-center w-10">Situação Órgão</th>
							<th class="text-center w-10">Qtd. Usuários Ativos</th>
							<th class="text-center w-10">Qtd. <fmt:message key="usuario.lotacoes"/> Ativas</th>
							<!-- <th class="text-center w-10">Externo</th>
							<th class="text-left w-10">Data Contrato</th> -->
							<th colspan="2" class="text-left w-10">Op&ccedil;&otilde;es</th>					
						</tr>
					</thead>
					
					<tbody>
						<siga:paginador maxItens="15" maxIndices="10" totalItens="${tamanho}"
							itens="${itens}" var="orgaoUsuario">

							<tr>
								<td class="text-left w-10">${orgaoUsuario[0].id}</td>
								<td class="text-left w-60">${orgaoUsuario[0].descricao}</td>
								<td class="text-center w-10">${orgaoUsuario[0].sigla}</td>
								<!-- <td class="text-center w-10">${orgaoUsuario[0].isExternoOrgaoUsu  == 1 ? 'SIM' : 'NÃO'}</td>
								<td class="text-left w-10"><fmt:formatDate value="${orgaoUsuario[1]}" pattern="dd/MM/yyyy" /></td> -->
								<td class="text-center w-10">${empty orgaoUsuario[0].hisDtFim ? "Ativo" : "Inativo"}</td>
								<td class="text-center w-10">${orgaoUsuario[2]}</td>
								<td class="text-center w-10">${orgaoUsuario[3]}</td>
								<td class="text-left w-10">
									<c:url var="url" value="/app/orgaoUsuario/editar">
										<c:param name="id" value="${orgaoUsuario[0].id}"></c:param>
									</c:url>
									<c:url var="urlAtivarInativar" value="/app/orgaoUsuario/ativarInativar">
										<c:param name="id" value="${orgaoUsuario[0].id}"></c:param>
									</c:url>
									<c:url var="urlHistorico" value="/app/orgaoUsuario/historico">
										<c:param name="id" value="${orgaoUsuario[0].id}"></c:param>
									</c:url>
									<!--<c:if test="${empty orgaoUsuarioSiglaLogado || orgaoUsuarioSiglaLogado eq orgaoUsuario[0].sigla}">
									<input type="button" value="Alterar"
										onclick="javascript:window.location.href='${url}'"
										class="btn btn-primary">
									</c:if>-->
									
									<div class="btn-group">								  
								  <c:choose>
									<c:when test="${empty orgaoUsuario[0].hisDtFim}">
										<a href='javascript:inativar("${urlAtivarInativar}", "${orgaoUsuario[0].descricao}", "${orgaoUsuario[2]}", "${orgaoUsuario[3]}")' class="btn btn-primary" role="button" 
											aria-pressed="true" style="min-width: 80px;">Inativar</a>
										<button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
										    <span class="sr-only"></span>
									    </button>
									</c:when>
									<c:otherwise>
										<a href="javascript:submitPost('${urlAtivarInativar}')" class="btn btn-danger" role="button" aria-pressed="true" style="min-width: 80px;">Ativar</a>
										<button type="button" class="btn btn-danger dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
										    <span class="sr-only"></span>
									    </button>
									</c:otherwise>
								  </c:choose>	  
								  <div class="dropdown-menu">						  
								  	<a href="${url}" class="dropdown-item" role="button" aria-pressed="true">Alterar</a>	
								  	<div class="dropdown-divider"></div>	
								  	<a href="${urlHistorico}" class="dropdown-item" role="button" aria-pressed="true" style="min-width: 80px;">Histórico</a>						   
								  </div>
								</div>		
									
												
								</td>
							<%--	<td align="left">									
	 			 					<a href="javascript:if (confirm('Deseja excluir o orgão?')) location.href='/siga/app/orgao/excluir?id=${orgao.idOrgao}';">
										<img style="display: inline;"
										src="/siga/css/famfamfam/icons/cancel_gray.png" title="Excluir orgão"							
										onmouseover="this.src='/siga/css/famfamfam/icons/cancel.png';" 
										onmouseout="this.src='/siga/css/famfamfam/icons/cancel_gray.png';"/>
									</a>															
								</td>
							 --%>							
							</tr>
						</siga:paginador>
					</tbody>
				</table>				
			
			<c:if test="${empty orgaoUsuarioSiglaLogado}">
			<div class="gt-table-buttons">
					<c:url var="url" value="/app/orgaoUsuario/editar"></c:url>
					<input type="button" value="Incluir"
						onclick="javascript:window.location.href='${url}'"
						class="btn btn-primary">
				</div>	
			</c:if>			
		</div>
</form>
<siga:siga-modal id="confirmacaoModal" exibirRodape="false" tituloADireita="Informa&ccedil;&atilde;o">
	<div class="modal-body">
     		
   	</div>
   	<div class="modal-footer">
     		<button type="button" class="btn btn-success" data-dismiss="modal">Ok</button>
	</div>
</siga:siga-modal>
</siga:pagina>