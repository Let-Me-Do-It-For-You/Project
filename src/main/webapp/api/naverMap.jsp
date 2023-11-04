<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>네이버 지도</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3weeoauxqb"></script>
</head>
<body>
    <div id="map" style="width:100%; height:800px;"></div>

    <script>

        var map = new naver.maps.Map('map', {
            center: new naver.maps.LatLng(37.391879, 126.919662),	// 안양대학교 좌표 기준으로 맵 로드
            zoom: 16
        });

    </script>

</body>
</html>