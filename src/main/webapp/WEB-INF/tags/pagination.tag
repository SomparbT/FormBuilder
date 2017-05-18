<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="href_path" required="true" type="java.lang.String"%>
<%@ attribute name="href_staticParameter" required="true" type="java.lang.String"%>
<%@ attribute name="href_dynamicParameter" required="true" type="java.lang.String"%>
<%@ attribute name="totalPages" required="true" type="java.lang.Integer"%>
<%@ attribute name="currentPage" required="true" type="java.lang.Integer"%>
<%@ tag body-content="scriptless"%>


<div class="text-center">
	<nav aria-label="Page navigation">
		<ul class="pagination">
			<c:if test="${currentPage ne 1 }">
				<li><a href="${href_path}?${href_staticParameter}&${href_dynamicParameter}=${currentPage - 1}" aria-label="Previous"> <span aria-hidden="true">&laquo;</span></a></li>
			</c:if>	
			<c:forEach begin="1" end="${totalPages}" step="1" var="i">
				<c:choose>
					<c:when test="${currentPage eq i }">
						<li class="active"><a href="" onclick="return false">${i}
						</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="${href_path}?${href_staticParameter}&${href_dynamicParameter}=${i}">${i}
						</a></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${currentPage ne totalPages }">
				<li><a href="${href_path}?${href_staticParameter}&${href_dynamicParameter}=${currentPage + 1}" aria-label="Next"> <span aria-hidden="true">&raquo;</span></a></li>
			</c:if>	
		</ul>
	</nav>
</div>
