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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ib" uri="I2pBoteTags" %>

<%--
    Valid actions:
        <default>         - show the "new email" form
        send              - send an email using the request data
        addToAddrBook     - add a recipient to the address book and return here
        lookup            - add one or more address book entries as recipients and return here
        addRecipientField - add a recipient field
        
    Other parameters:
        new    - true for new contact, false for existing contact
--%>

<c:choose>
    <c:when test="${param.action eq 'send'}">
        <jsp:forward page="sendEmail.jsp"/>
    </c:when>
    <c:when test="${param.action eq 'addToAddrBook'}">
        <c:set var="destparam" value="${param.destparamname}"/>
        <jsp:forward page="editContact.jsp">
            <jsp:param name="new" value="true"/>
            <jsp:param name="destination" value="${ib:escapeQuotes(param[destparam])}"/>
            <jsp:param name="forwardUrl" value="newEmail.jsp"/>
            <jsp:param name="backUrl" value="newEmail.jsp"/>
            <jsp:param name="paramsToCopy" value="recipient*,to*,cc*,bcc*,replyto*,subject,message,forwardUrl,backUrl,paramsToCopy"/>
        </jsp:forward>
    </c:when>
    <c:when test="${param.action eq 'lookup'}">
        <jsp:forward page="addressBook.jsp">
            <jsp:param name="select" value="true"/>
            <jsp:param name="forwardUrl" value="newEmail.jsp"/>
            <jsp:param name="paramsToCopy" value="recipient*,to*,cc*,bcc*,replyto*,subject,message,forwardUrl"/>
        </jsp:forward>
    </c:when>
</c:choose>

<ib:message key="New Email" var="title"scope="request"/>
<jsp:include page="header.jsp"/>

<div class="main">
    <form action="newEmail.jsp" method="post">
        <table>
            <tr>
                <td>
                    <ib:message key="From:"/>
                </td>
                <td>
                    <select name="sender">
                        <option value="anonymous">Anonymous</option>
                        <c:forEach items="${ib:getIdentities().all}" var="identity">
                            <c:set var="selected" value=""/>
                            <c:if test="${fn:contains(param.sender, identity.key)}">
                                <c:set var="selected" value=" selected"/>
                            </c:if>
                            <c:if test="${empty param.sender && identity.default}">
                                <c:set var="selected" value=" selected"/>
                            </c:if>
                            <option value="${identity.publicName} &lt;${identity.key}&gt;"${selected}>
                                ${identity.publicName}
                                <c:if test="${!empty identity.description}"> - ${identity.description}</c:if>
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            
            <%--
                Add an address line for each recipient# parameter, where # is a number.
                Fill in selectedContacts entries for empty recipient addresses if available.
            --%>
            <c:set var="maxRecipientIndex" value="-1"/>
            <c:set var="selectedContacts" value="${paramValues.selectedContact}"/>
            <c:set var="nextSelectedContactIndex" value="0"/>   <%-- An index into the selectedContacts array --%>
            <c:forEach var="parameter" items="${ib:getSortedRecipientParams(param)}">
                <c:set var="recipientField" value="${parameter.key}"/>
                <c:set var="recipient" value="${parameter.value}"/>
                
                <%-- If the address is blank, and there is at least one remaining selectedContacts entry, fill it in --%>
                <c:if test="${empty recipient and nextSelectedContactIndex lt fn:length(selectedContacts)}">
                    <c:set var="recipient" value="${selectedContacts[nextSelectedContactIndex]}"/>
                    <c:set var="nextSelectedContactIndex" value="${nextSelectedContactIndex + 1}"/>
                </c:if>
                
                <c:set var="recipientIndex" value="${fn:substringAfter(recipientField, 'recipient')}"/>
                <c:if test="${recipientIndex gt maxRecipientIndex}">
                    <c:set var="maxRecipientIndex" value="${recipientIndex}"/>
                </c:if>
                <tr><td>
                    <c:set var="recipientTypeField" value="recipientType${recipientIndex}"/>
                    <c:set var="recipientType" value="${param[recipientTypeField]}"/>
                    <select name="${recipientTypeField}">
                        <c:set var="toSelected" value="${recipientType eq 'to' ? ' selected' : ''}"/>
                        <c:set var="ccSelected" value="${recipientType eq 'cc' ? ' selected' : ''}"/>
                        <c:set var="bccSelected" value="${recipientType eq 'bcc' ? ' selected' : ''}"/>
                        <c:set var="replytoSelected" value="${recipientType eq 'replyto' ? ' selected' : ''}"/>
                        <option value="to"${toSelected}><ib:message key="To:"/></option>
                        <option value="cc"${ccSelected}><ib:message key="CC:"/></option>
                        <option value="bcc"${bccSelected}><ib:message key="BCC:"/></option>
                        <option value="replyto"${replytoSelected}><ib:message key="Reply To:"/></option>
                    </select>
                </td><td>
                    <input type="text" size="80" name="${recipientField}" value="${ib:escapeQuotes(recipient)}"/>
                </td></tr>
            </c:forEach>
            <%-- Add an address line for each selectedContact parameter (from addressbook.jsp) --%>
            <c:if test="${!empty selectedContacts}">
                <c:forEach var="destination" items="${selectedContacts}" varStatus="status">
                    <c:if test="${status.index ge nextSelectedContactIndex}">
                        <c:set var="maxRecipientIndex" value="${maxRecipientIndex+1}"/>
                        <tr><td>
                            <select name="recipientType${maxRecipientIndex}">
                                <option value="to"><ib:message key="To:"/></option>
                                <option value="cc"><ib:message key="CC:"/></option>
                                <option value="bcc"><ib:message key="BCC:"/></option>
                                <option value="replyto"><ib:message key="Reply To:"/></option>
                            </select>
                        </td><td>
                            <input type="text" size="80" name="recipient${maxRecipientIndex}" value="${ib:escapeQuotes(destination)}"/>
                        </td></tr>
                    </c:if>
                </c:forEach>
            </c:if>
            <%-- Make sure there is at least one recipient field --%>
            <c:if test="${maxRecipientIndex lt 0}">
                <c:set var="maxRecipientIndex" value="0"/>
                <tr><td>
                    <select name="recipientType${maxRecipientIndex}">
                        <option value="to"><ib:message key="To:"/></option>
                        <option value="cc"><ib:message key="CC:"/></option>
                        <option value="bcc"><ib:message key="BCC:"/></option>
                        <option value="replyto"><ib:message key="Reply To:"/></option>
                    </select>
                </td><td>
                    <c:set var="newRecipientField" value="recipient${maxRecipientIndex}"/>
                    <input type="text" size="80" name="${newRecipientField}"/>
                    <input type="hidden" name="destparamname" value="${newRecipientField}"/>
                    <button type="submit" name="action" value="addToAddrBook">&#x2794;<img src="images/addressbook.gif"/></button>
                </td></tr>
            </c:if>
            <%-- Add a blank address line if action=addRecipientField --%>
            <c:if test="${param.action eq 'addRecipientField'}">
                <c:set var="maxRecipientIndex" value="${maxRecipientIndex+1}"/>
                <tr><td>
                    <select name="recipientType${maxRecipientIndex}">
                        <option value="to"><ib:message key="To:"/></option>
                        <option value="cc"><ib:message key="CC:"/></option>
                        <option value="bcc"><ib:message key="BCC:"/></option>
                        <option value="replyto"><ib:message key="Reply To:"/></option>
                    </select>
                </td><td>
                    <c:set var="newRecipientField" value="recipient${maxRecipientIndex}"/>
                    <input type="text" size="80" name="${ib:escapeQuotes(newRecipientField)}"/>
                    <input type="hidden" name="destparamname" value="${ib:escapeQuotes(newRecipientField)}"/>
                    <button type="submit" name="action" value="addToAddrBook">&#x2794;<img src="images/addressbook.gif"/></button>
                </td></tr>
            </c:if>

            <tr>
                <td/>
                <td style="text-align: right;">
                    <button type="submit" name="action" value="addRecipientField">+</button>
                    <button type="submit" name="action" value="lookup"><ib:message key="Addr. Book..."/></button>
                </td>
            </tr>
            <tr>
                <td valign="top"><br/><ib:message key="Subject:"/></td>
                <td><input class="widetextfield" type="text" size="80" name="subject" value="${ib:escapeQuotes(param.subject)}"/></td>
            </tr>
            <tr>
                <td valign="top"><br/><ib:message key="Message:"/></td>
                <td>
                    <textarea rows="30" cols="80" name="message"><c:if test="${!empty param.quoteMsgId}">
<%-- The following lines are not indented because the indentation would show up as blank chars on the textarea --%>
<c:set var="origEmail" value="${ib:getEmail(param.quoteMsgFolder, param.quoteMsgId)}"/>
<ib:message key="{0} wrote:" hide="true">
    <ib:param value="${ib:getShortSenderName(origEmail.sender, 50)}"></ib:param>
</ib:message><ib:quote text="${origEmail.text}"/></c:if><c:if test="${empty param.quoteMsgId}">${param.message}</c:if></textarea>
                </td>
            </tr>
            <tr>
                <td colspan=3 align="center">
                    <button type="submit" name="action" value="send"><ib:message key="Send"/></button>
                    <button type="submit" name="action" disabled="disabled"><ib:message key="Save"/></button>
                </td>
            </tr>
        </table>
    </form>
</div>

<jsp:include page="footer.jsp"/>
