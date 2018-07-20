
import GGARest
class <%= entityName %>Dto : JsonBaseObject {

    var id: NSNumber? = null

    <% fields.forEach(function(field){ %>
    var <%=field.fieldName%>: <%=field.fieldType%>
    <% }); %>
}
