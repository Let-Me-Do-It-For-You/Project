<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO1"%>
<%@ page import="bbs.BbsDTO1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>매장 위치</title>
    
</head>
<body>
<%
String restaurantAddress = "";
String restaurantName = "";
if (request.getParameter("restaurantAddress") != null) {
    restaurantAddress = request.getParameter("restaurantAddress");
}
if (request.getParameter("restaurantName") != null) {
	restaurantName = request.getParameter("restaurantName");
}
%>

<p style="margin-top: -12px">
    <em class="link"></em>
</p>
<div id="map" style="width: 100%; height: 390px;"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d432bc97f9b67c8d47581fb439a8d7a3&libraries=services"></script>
<script>
var mapContainer = document.getElementById('map'); // 지도를 표시할 div
var mapOption = {
    center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};

// 지도를 생성합니다
var map = new kakao.maps.Map(mapContainer, mapOption);

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

// 주소로 좌표를 검색합니다
geocoder.addressSearch("<%=restaurantAddress%>", function(result, status) {

    // 정상적으로 검색이 완료됐으면
    if (status === kakao.maps.services.Status.OK) {

        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        // 결과값으로 받은 위치를 마커로 표시합니다
        var marker = new kakao.maps.Marker({
            map: map,
            position: coords
        });

        // 인포윈도우로 장소에 대한 설명을 표시합니다
        var infowindow = new kakao.maps.InfoWindow({
        	content: '<div style="width:150px;text-align:center;padding:6px 0;"><%=restaurantName%></div>'
        });
        infowindow.open(map, marker);

        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
        map.setCenter(coords);
    }
});
</script>

</body>
</html>