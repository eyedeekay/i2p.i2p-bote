<%--
 Copyright (C) 2009  HungryHobo@mail.i2p
 
 The GPG fingerprint for HungryHobo@mail.i2p is:
 6DD3 EAA2 9990 29BC 4AD2 7486 1E2C 7B61 76DC DC12
 
 This file is part of I2P-Bote.
 I2P-Bote is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 I2P-Bote is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with I2P-Bote.  If not, see <http://www.gnu.org/licenses/>.
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ib" uri="I2pBoteTags" %>

<jsp:include page="header.jsp">
    <jsp:param name="title" value="${param.path}"/>
</jsp:include>

This is the <b>${param.path}</b> folder.

<div class="main">
<div class="folder">
	<table>
	    <tr>
	        <th>Sender</th><th>Subject</th><th>Date</th>
	    </tr>
	    <c:set var="folderName" value="Inbox"/>
	    <c:forEach items="${ib:getMailFolder(folderName).elements}" var="email">
	        <tr>
                <c:set var="sender" value="${email.subject}"/>
                <c:if test="${empty subject}">
                    <c:set var="sender" value="Anonymous"/>
                </c:if>
                
                <c:set var="date" value="${email.date}"/>
                <c:if test="${empty date}">
                    <c:set var="date" value="${email.dateString}"/>
                </c:if>
                <c:if test="${empty date}">
                    <c:set var="date" value="Unknown"/>
                </c:if>
                
                <c:set var="subject" value="${email.subject}"/>
                <c:if test="${empty subject}">
                    <c:set var="subject" value="(No subject)"/>
                </c:if>
                <c:set var="subject" value="<a href=showEmail.jsp?folder=${folderName}&messageID=${email.messageID}>${subject}</a>"/>
                
	            <td>${sender}</td><td>${subject}</td><td>${date}</td>
	        </tr>
	    </c:forEach>
	</table>
</div>
</div>

<jsp:include page="footer.jsp"/>