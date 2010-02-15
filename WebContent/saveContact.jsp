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


<c:if test="${param.action == 'Cancel'}">
    <jsp:forward page="addressBook.jsp"/>
</c:if>

<c:choose>
    <c:when test="${empty param.destination}">
        <c:set var="errorMessage" value="Please fill in the Destination field."/>
    </c:when>
    <c:when test="${empty param.name}">
        <c:set var="errorMessage" value="Please fill in the Name field."/>
    </c:when>
    <c:otherwise>
        <c:set var="errorMessage" value="${ib:saveContact(param.destination, param.name)}"/>
    </c:otherwise>
</c:choose>

<c:if test="${empty errorMessage}">
    <jsp:forward page="addressBook.jsp">
        <jsp:param name="infoMessage" value="The contact has been saved."/>
    </jsp:forward>
</c:if>
<c:if test="${!empty errorMessage}">
    <jsp:forward page="editContact.jsp">
        <jsp:param name="errorMessage" value="${errorMessage}"/>
    </jsp:forward>
</c:if>