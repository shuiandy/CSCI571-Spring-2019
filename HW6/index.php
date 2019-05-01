<?php

$keyword = $category = $new = $used = $miles = $unspecified = $nearby = $zip_code = $geo = '';
$json = $jsonDetail = null;
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $keyword = rawurlencode($_POST['keyword']);

    if ($_POST['category'] == 'All') {
        $category = '';
    } else {
        $category = '&categoryId=' . $_POST['category'];
    }
    $i = 1;
    $local = isset($_POST['local']) ? '&itemFilter(' . $i . ').name=LocalPickupOnly&itemFilter(' . $i++ . ').value=true' : '';
    $free = isset($_POST['free']) ? '&itemFilter(' . $i . ').name=FreeShippingOnly&itemFilter(' . $i++ . ').value=true' : '';
    if (isset($_POST['new']) || isset($_POST['used']) || isset($_POST['unspecified'])) {
        $j = 0;
        $condition = '&itemFilter(' . $i . ').name=Condition';
        $new = isset($_POST['new']) ? '&itemFilter(' . $i . ').value(' . $j++ . ')=New' : '';
        $used = isset($_POST['used']) ? '&itemFilter(' . $i . ').value(' . $j++ . ')=Used' : '';
        $unspecified = isset($_POST['unspecified']) ? '&itemFilter(' . $i . ').value(' . $j++ . ')=Unspecified' : '';
        $i++;
    } else {
        $condition = '';
    }
    if (isset($_POST['nearby'])) {
        $geo = rawurlencode($_POST['location']);
        $miles = rawurlencode($_POST['miles']);
        $nearby = '&itemFilter(' . $i . ').name=MaxDistance&itemFilter(' . $i . ').value=' . $miles;
        $zip_code = isset($_POST['zip_code']) ? '&buyerPostalCode=' . $_POST['zip_code'] : '&buyerPostalCode=' . $geo;
        $i++;
    }
    $url = 'http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=ShuaiHu-homework-PRD-616e2f5cf-bcc0e9d3&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=' . $keyword . '&paginationInput.entriesPerPage=20' . $category . '&itemFilter(0).name=HideDuplicateItems&itemFilter(0).value=true' . $local . $free . $condition . $new . $used . $unspecified . $nearby . $zip_code;
    $json = file_get_contents($url);
    exit($json);
}
if (isset($_REQUEST["id"])) {
    $itemid = $_REQUEST["id"];
    getDetails($itemid);
}
if (isset($_REQUEST["uid"])) {
    $itemid = $_REQUEST["uid"];
    similar($itemid);
}

function getDetails($itemid)
{
    $url = 'http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=ShuaiHu-homework-PRD-616e2f5cf-bcc0e9d3&siteid=0&version=967&ItemID=' . $itemid . '&IncludeSelector=Description,Details,ItemSpecifics';
    $detail = file_get_contents($url);
    $detail_tmp = json_decode($detail);
    if (file_exists("./tmp/tmp.html")) {
        unlink("./tmp/tmp.html");
    }
    if (isset($detail_tmp->Item->Description)) {
        $detail_desc = $detail_tmp->Item->Description;
        file_put_contents("./tmp/tmp.html", $detail_desc);
    } else {
        $detail_desc = null;
        exit($detail);
    }

    exit($detail);
}

function similar($itemid)
{
    $url = 'http://svcs.ebay.com/MerchandisingService?OPERATION-NAME=getSimilarItems&SERVICE-NAME=MerchandisingService&SERVICE-VERSION=1.1.0&CONSUMER-ID=ShuaiHu-homework-PRD-616e2f5cf-bcc0e9d3&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&itemId=' . $itemid . '&maxResults=8';
    $similar = file_get_contents($url);
    exit($similar);
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Product Search</title>
    <meta name="referrer" content="no-referrer">
    <style type="text/css">
        body {
            text-align: center;
        }

        #search_form h2 {
            font-family: serif;
            font-size: 35px;
            font-style: italic;
            text-align: center;
            margin-top: 1px;
            margin-bottom: 5px;
        }

        h3 {
            font-size: 40px;
            margin-top: 15px;
            margin-bottom: 5px;
            text-align: :center;
        }

        #search_form hr {
            color: rgb(195, 195, 195);
            margin: auto;
        }

        #buttons {
            margin-top: 30px;
            text-align: center;
        }

        #formbox {
            border: 3px;
            border-color: rgb(195, 195, 195);
            height: 270px;
            width: 600px;
            margin: auto;
            padding: 10px;
            background-color: rgb(249, 249, 249);
            text-align: left;
            border-style: solid;
        }

        #location_list {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: inline;
            position: absolute;
        }

        #keyword,
        #category,
        #location_list {
            margin: 10px;
        }

        #new,
        #used,
        #unspecified {
            margin-left: 20px;
            margin-top: 10px;
        }

        #local,
        #free {
            margin-top: 10px;
            margin-left: 42px;
        }

        #miles {
            margin-top: 10px;
            margin-left: 30px;
            margin-right: 3px;
            width: 50px;
        }

        #results table {
            text-align: center;
            position: relative;
            border-collapse: collapse;
            width: 80%;
            margin-left: auto;
            margin-right: auto;
            margin-top: 20px;
        }

        #detail table tbody {
            text-align: center;
            position: relative;
            border-collapse: collapse;
            width: 80%;
            margin-top: 5px;
        }

        table,
        td,
        th {
            border: 1px solid lightgray;
        }

        th {
            text-align: center;
            height: 20px;
            font-size: 17px;
        }

        td {
            text-align: left;
            height: 50px;
            padding-left: 5px;
        }

        table.no_results_found th {
            background-color: #FAFAFA;
            border: 2px solid lightgrey;
            font-weight: lighter;
        }

        img.detail {
            height: 260px;
        }

        table.table_detail {
            height: 50px;
        }

        table.table_detail th {
            width: 150px;
            text-align: left;
            height: 10px;
        }

        table.table_detail td {
            width: 50%;
            height: 10px;
        }

        #similar_page {
            position: relative;
            text-align: center;
            margin: auto;
            overflow-x: scroll;
            float: none;
            clear: both;
            width: 65%;
        }

        #similar_page table {
            border: none;
            border-spacing: 50px 2px;
        }

        #similar_page table tbody {
            text-align: center;
            position: relative;
            max-width: 60%;
            overflow-x: scroll;
            border-collapse: collapse;
            margin-top: 15px;
        }

        #similar_page tr {
            border: none;
        }

        #similar_page td {
            border: none;
            text-align: center;
        }

        .error {
            margin: auto;
            border-width: 2px;
            margin-top: 10px;
            text-align: center;
            width: 35%;
            background-color: lightgray;
        }

        a:link {
            color: black;
            text-decoration: none;
        }

        a:hover {
            color: gray;
            text-decoration: none;
        }

        #detail table {
            text-align: center;
            position: relative;
            border-collapse: collapse;
            width: 50%;
            margin-left: auto;
            margin-right: auto;
            margin-top: 20px;
        }

        #result_img {
            width: 90px;
            height: 90px;
        }

        #result_img img {
            width: 80px;
            height: 80px;
        }

        #result_ship {
            width: 135px;
        }

        #result_tr {
            height: 10px;
        }

        #result_zip {
            width: 70px;
        }

        #similar_img {
            width: 200px;
            height: 200px;
        }

        #similar_title {
            min-width: 200px;
        }

        #index_table {
            max-width: 50px;
        }

        #seller_page {
            width: 80%;
            margin: auto;
            text-align: center;
        }
    </style>


</head>

<body>
    <div id="formbox">
        <form id="search_form" method="POST" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>">
            <h2>Product Search</h2>
            <hr>
            <label for="keyword"><b>Keyword</b></label>
            <input type="text" name="keyword" id="keyword" required="required" value="<?php echo $keyword ?>">
            <br>
            <label for=" category"><b>Category</b></label>
            <select name="category" id="category">
                <option value='All'>All Categories</option>
                <option value="550">Art</option>
                <option value="2984">Baby</option>
                <option value="267">Books</option>
                <option value="11450">Clothing, Shoes & Accessories</option>
                <option value="58058">Computers/Tablets & Networking</option>
                <option value="26395">Health & Beauty</option>
                <option value="11233">Music</option>
                <option value="1249">Video Games & Consoles</option>
            </select>
            <br>
            <label for="condition"><b>Condition</b></label>
            <input name="new[]" id="new" type="checkbox">
            <label for="new">New</label>
            <input name="used[]" id="used" type="checkbox">
            <label for="used">Used</label>
            <input name="unspecified[]" id="unspecified" type="checkbox">
            <label for="unspecified">Unspecified</label>
            <br>
            <label for="ship"><b>Shipping Options</b></label>
            <input name="local[]" id="local" type="checkbox">
            <label for="local">Local Pickup</label>
            <input name="free[]" id="free" type="checkbox">
            <label for="free">Free Shipping</label>
            <br>
            <input name="nearby[]" id="nearby" type="checkbox">
            <label for="nearby"><b>Enable Nearby Search</b></label>
            <input name="miles" id="miles" type="text" value="10" disabled>
            <label for="miles" id="mile" style="color: gray"><b>miles from</b></label>
            <ul id="location_list">
                <li>
                    <input type="radio" id="here" name="location" disabled=false checked="checked">
                    <label for="here" id="check" style="color: gray">Here</label>
                </li>
                <li>
                    <input type="radio" id="zip" name="location">
                    <input type="text" id="zip_code" name="zip_code" disabled=true placeholder="zip code" required="required">
                </li>
            </ul>
            <div id="buttons">
                <button id="search" name="search" disabled=true>Search</button>
                <input id="clear" name="clear" onclick="clear_page()" type="button" value="Clear">
            </div>
        </form>
    </div>
    <input type="hidden" name="geo" id="geo">
    <!-- <iframe id="id_iframe" name="nm_iframe" style="display:none;"></iframe> -->
    <div style=" align-items: center;justify-content: center">
        <div id="results" style="position:relative;float:none;clear:both;"></div>
        <div id="detail" style="position:relative;float:none;clear:both;"></div>
        <div id="misc" style="position:relative;float:none;clear:both;"></div>
        <!-- <div id="seller_page" style="display: none"></div> -->
    </div>



    <script type="text/javascript">
        get_zip();
        var form = document.getElementById("search_form");
        var nearby_check = document.getElementById("nearby");
        var zip = document.getElementById("zip");
        var here_checked = document.getElementById("here");
        var clear = document.getElementById("clear");

        nearby_check.addEventListener("change", function() {
            if (this.checked) {
                here_checked.disabled = false;
                document.getElementById("miles").disabled = false;
                document.getElementById("mile").style.color = "black";
                document.getElementById("check").style.color = "black";
                zip.disabled = false;
            } else {
                here_checked.disabled = true;
                here_checked.checked = "checked";
                document.getElementById("miles").disabled = true;
                document.getElementById("zip_code").disabled = true;
                document.getElementById("check").style.color = "gray";
                document.getElementById("mile").style.color = "gray";
                zip.disabled = true;

            }
        });

        here_checked.addEventListener("change", function() {
            if (this.checked) {
                document.getElementById("zip_code").disabled = true;
            } else {
                document.getElementById("zip_code").disabled = false;
            }

        });

        zip.addEventListener("change", function() {
            if (this.checked) {
                document.getElementById("zip_code").disabled = false;
            } else {
                document.getElementById("zip_code").disabled = true;
            }

        });
        form.addEventListener("submit", function(event) {
            event.preventDefault();
            if (nearby_check.checked) {
                checkmiles = checkMile();
                if (checkmiles) {
                    if (document.getElementById("zip_code").disabled == false) {
                        check = checkZip();
                        if (check) {
                            submit_form();
                        }
                    } else {
                        submit_form();
                    }
                }
            } else {
                submit_form();
            }
        }, false);

        function submit_form() {
            var url = form.action;
            var params = "";
            var data = new FormData(form);
            for (const entry of data) {
                params += entry[0] + "=" + encodeURIComponent(entry[1]) + "&";
            }
            params = params.slice(0, -1);
            var xhttp = new XMLHttpRequest();
            xhttp.open("POST", url, false);
            xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhttp.send(params);
            results = JSON.parse(xhttp.responseText);
            show_result(results);
        }

        here_checked.addEventListener("change", function() {
            if (this.checked) {
                document.getElementById("zip_code").disabled = true;
            }
        });

        function remove_all_child(nodename) {
            var node = document.getElementById(nodename);
            while (node && node.firstChild) {
                node.removeChild(node.firstChild);
            }
        }

        function checkZip() {
            var zip_code = document.getElementById("zip_code");
            var reg = new RegExp(/^\d{5}$/);
            if (!reg.test(zip_code.value)) {
                html_text = "<div class = 'error' style = 'text-align: center;'>Zipcode is invalid</div>";
                document.getElementById("results").innerHTML = html_text;
            } else {
                return true;
            }
        }

        function checkMile() {
            var miles = document.getElementById("miles");
            var reg = new RegExp(/^\d+$/);
            if (!reg.test(miles.value)) {
                html_text = "<div class = 'error' style = 'text-align: center;'>Distance is invalid</div>";
                document.getElementById("results").innerHTML = html_text;
            } else {
                return true;
            }
        }

        function get_zip() {
            xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "http://ip-api.com/json", false);
            xmlhttp.send();
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                response = xmlhttp.responseText;
                jsonOb = JSON.parse(response);
                zip = jsonOb.zip.substring(0, 5);
                document.getElementById("here").value = zip;
                document.getElementById("search").disabled = false;
            }
        }


        function clear_page() {
            remove_all_child("results");
            remove_all_child("misc");
            remove_all_child("detail");
            document.getElementById("search_form").reset();
            document.getElementById("miles").disabled = true;
            document.getElementById("zip_code").disabled = true;
            document.getElementById("check").style.color = "gray";
            document.getElementById("mile").style.color = "gray";

            zip_code.disabled = true;
        }

        function show_details(itemid) {
            html_text = "";
            remove_all_child("results");
            remove_all_child("misc");
            remove_all_child("detail");
            var xmlhttp = new XMLHttpRequest();

            var jsonDetail;
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    jsonDetail = JSON.parse(xmlhttp.responseText);
                    generate_details(jsonDetail);
                }
            };
            xmlhttp.open("GET", "index.php?id=" + itemid, false);
            xmlhttp.send();
        }

        function show_result(results) {
            html_text = "";
            remove_all_child("results");
            remove_all_child("detail");
            remove_all_child("misc");
            jsonResult = results.findItemsAdvancedResponse[0];
            if (jsonResult.ack == "Failure" || jsonResult.searchResult[0].item == undefined) {
                html_text = "<div class ='error'>No Records has been found</div>";
            } else {
                rows = jsonResult.searchResult[0].item;
                if (rows.length == 0) {
                    html_text = "<div class='error'>No Records has been found</div>";
                } else {
                    html_text = "<table border='1'><thead style='font-size: 20px'><tr id='result_tr'>";
                    html_text += "<th id='index_table'>Index</th>";
                    html_text += "<th>Photo</th>";
                    html_text += "<th>Name</th>";
                    html_text += "<th >Price</th>";
                    html_text += "<th id='result_zip'>Zip code</th>";
                    html_text += "<th>Condition</th>";
                    html_text += "<th id='result_ship'>Shipping Option</th>";
                    html_text += "</tr></thead><tbody>";
                    for (var i = 0; i < rows.length; i++) {
                        jsonObj = rows[i];
                        // index
                        html_text += "<td id='index_table'>" + (i + 1) + "</td>";
                        // photo
                        if (jsonObj.hasOwnProperty("galleryURL")) {
                            html_text += "<td id='result_img'><img src='" + jsonObj.galleryURL + "'</td>";
                        } else {
                            html_text += "<td id='result_img'>N/A</td>";
                        }
                        html_text += "<td><a href='javaScript:void(0)' onclick='show_details(" + jsonObj.itemId + ")'" +
                            ">" + jsonObj.title + "</a></td>";
                        // price
                        html_text += "<td> $" + jsonObj.sellingStatus[0].currentPrice[0].__value__ + "</td>";
                        // zipcode
                        if (jsonObj.hasOwnProperty("postalCode")) {
                            html_text += "<td>" + jsonObj.postalCode + "</td>";
                        } else {
                            html_text += "<td> N/A </td>";
                        }
                        // condition
                        if (jsonObj.hasOwnProperty("condition")) {
                            if (jsonObj.condition[0].conditionDisplayName == "New") {
                                html_text += "<td> Brand " + jsonObj.condition[0].conditionDisplayName + "</td>";
                            } else {
                                html_text += "<td>" + jsonObj.condition[0].conditionDisplayName + "</td>";
                            }
                        } else {
                            html_text += "<td> N/A </td>";
                        }
                        // shipping option
                        if (jsonObj.shippingInfo[0].hasOwnProperty("shippingServiceCost")) {
                            if (jsonObj.shippingInfo[0].shippingServiceCost[0].__value__ == "0.0") {
                                if (jsonObj.shippingInfo[0].shippingType == "Free") {
                                    html_text += "<td>" + jsonObj.shippingInfo[0].shippingType + " Shipping</td>";
                                } else {
                                    html_text += "<td> N/A </td>";
                                }
                            } else {
                                html_text += "<td> $" + jsonObj.shippingInfo[0].shippingServiceCost[0].__value__ + "</td>";
                            }
                        } else {
                            html_text += "<td> N/A </td>";
                        }
                        html_text += "</tr>";
                    }
                    html_text += "</tbody></table>";
                }

            }
            document.getElementById("results").innerHTML = html_text;
        }


        function generate_details(json) {
            remove_all_child("results");
            remove_all_child("misc");
            remove_all_child("detail");
            html_text = "";
            html_misc = "";
            var detail_div = document.getElementById("results");
            jsonDetail = json;
            if (jsonDetail.Ack == "Failure") {
                html_text = "<div class = 'error'>No Records has been found</div>";
            } else {
                rows = jsonDetail.Item;
                if (rows.length == 0) {
                    html_text = "<div class='error'>No Records has been found</div>";
                } else {
                    html_text += "<h3><b>Item Details</b></h3>";
                    html_text += "<table class='table_detail'><tbody>";
                    if (rows.hasOwnProperty("PictureURL") && rows.PictureURL.length != 0) {
                        html_text += "<tr><th style='height: 100'><b>Photo</b></th>";
                        html_text += "<td style='height: 100'><img class='detail' src='" + rows.PictureURL[0] +
                            "'></td></tr>";
                    }

                    if (rows.hasOwnProperty("Title")) {
                        html_text += "<tr><th><b>Title</b></th>";
                        html_text += "<td>" + rows.Title + "</td></tr>";
                    }

                    if (rows.hasOwnProperty("Subtitle")) {
                        html_text += "<tr><th><b>SubTitle</b></th>";
                        html_text += "<td>" + rows.Subtitle + "</td></tr>";
                    }

                    if (rows.hasOwnProperty("CurrentPrice")) {
                        html_text += "<tr><th><b>Price</b></th>";
                        html_text += "<td>" + rows.CurrentPrice.Value + " " + rows.CurrentPrice.CurrencyID + "</td></tr>";
                    }

                    if (rows.hasOwnProperty("Location")) {
                        html_text += "<tr><th><b>Location</b></th>";
                        html_text += "<td>" + rows.Location + ", " + rows.PostalCode + "</td></tr>";
                    }

                    if (rows.hasOwnProperty("Seller")) {
                        html_text += "<tr><th><b>Seller</b></th>";
                        html_text += "<td>" + rows.Seller.UserID + "</td></tr>";
                    }

                    if (rows.hasOwnProperty("ReturnPolicy")) {
                        html_text += "<tr><th><b>Return Policy(US)</b></th>";
                        html_text += "<td>" + rows.ReturnPolicy.ReturnsAccepted + " within " + rows.ReturnPolicy
                            .ReturnsWithin + "</td></tr>";
                    }

                    if (rows.hasOwnProperty("ItemSpecifics")) {
                        for (var j = 0; j < rows.ItemSpecifics.NameValueList.length; j++) {
                            html_text += "<tr><th><b>" + rows.ItemSpecifics.NameValueList[j].Name + "</b></th>";
                            html_text += "<td>" + rows.ItemSpecifics.NameValueList[j].Value[0] + "</td></tr>";
                        }
                    } else {
                        html_text += "<tr><th><b>No Detail Info from Seller</b></th>";
                        html_text += "<td></td></tr>";
                    }
                    html_text += "</tbody></table>";
                    html_text += "<br>";
                    html_misc +=
                        "<div style = 'font-size: 20px; color: gray; text-align: center'> click to show seller message </div>";
                    html_misc += "<br>";
                    has_massage = rows.Description == "" ? false : true;
                    html_misc += "<div id='seller_button'><a href='javaScript:void(0)' onclick='show_message(" + rows
                        .ItemID + "," + has_massage + ")'><img src='arrow-down.png' width='40px'></a></div>";
                    html_misc += "<div id='seller_page'></div>";
                    html_misc += "<br>";
                    html_misc +=
                        "<div style = 'font-size: 20px; color: gray; text-align: center'> click to show similar items </div>";
                    html_misc += "<br>";
                    html_misc += "<div id='similar_button'><a href='javaScript:void(0)' onclick='show_similar(" + rows
                        .ItemID + "," + has_massage + ")'><img src='arrow-down.png' width='40px'></a></div>";
                    html_misc += "<div id='similar_page'></div>";

                }
            }
            document.getElementById("detail").innerHTML = html_text;
            document.getElementById("misc").innerHTML = html_misc;
        }

        function show_message(itemid, has_message) {

            document.getElementById("seller_button").innerHTML = "<a href='javaScript:void(0)' onclick='hide_message(" +
                itemid + "," + has_massage + ")'><img src='arrow-up.png' width='40px'></a>";
            document.getElementById("seller_page").style.display = "block";
            document.getElementById("similar_page").style.display = "none";
            document.getElementById("similar_page").innerHTML = "";
            document.getElementById("similar_page").style.border = "none";
            document.getElementById("similar_button").innerHTML = "<a href='javaScript:void(0)' onclick='show_similar(" +
                itemid + "," + has_massage + ")'><img src='arrow-down.png' width='40px'></a>";
            var message_div = document.getElementById("seller_page");
            if (!has_message) {
                message_div.innerHTML = "<div class='error'><b>No Seller Message found.</b></div>";
            } else {
                message_div.innerHTML =
                    '<iframe id="iFrame1" name="iFrame1" width="100%" onload="this.height=iFrame1.document.body.scrollHeight" frameborder="0" src="/tmp/tmp.html"> </iframe>';
            }
        }

        function hide_message(itemid, has_message) {
            document.getElementById("seller_page").style.display = "none";
            document.getElementById("seller_button").innerHTML = "<a href='javaScript:void(0)' onclick='show_message(" +
                itemid + "," + has_massage + ")'><img src='arrow-down.png' width='40px'></a>";
        }

        function show_similar(itemid, has_message) {

            if (document.getElementById("similar_page").innerHTML == "") {
                var xmlhttp = new XMLHttpRequest();
                var jsonSimilar;
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        jsonSimilar = JSON.parse(xmlhttp.responseText);
                        jsonSimilar = jsonSimilar.getSimilarItemsResponse;
                    }
                };
                xmlhttp.open("GET", "index.php?uid=" + itemid, false);
                xmlhttp.send();
                html_text = "";
                if (jsonSimilar.ack == "Failure" || jsonSimilar.itemRecommendations.item.length == 0) {
                    html_text = "<div><b>No Simliar Item found.</b></div>";
                } else {
                    var rowss = jsonSimilar.itemRecommendations.item;
                    html_text += "<table>";
                    html_text += "<tr>";
                    // photo
                    for (var i = 0; i < rowss.length; i++) {
                        html_text += "<td id='similar_img'><img src='" + rowss[i].imageURL + "'</td>";
                    }
                    html_text += "</tr>";
                    html_text += "<tr>";
                    // title
                    for (var i = 0; i < rowss.length; i++) {
                        html_text += "<td id='similar_title'><a href='javaScript:void(0)' onclick='show_details(" + rowss[i]
                            .itemId + ")'" + ">" + rowss[i].title + "</a></td>";
                    }
                    html_text += "</tr>";
                    html_text += "<tr>";
                    // price
                    for (var i = 0; i < rowss.length; i++) {
                        if (rowss[i].buyItNowPrice.__value__ != "0.00") {
                            html_text += "<td><b> $" + rowss[i].buyItNowPrice.__value__ + "</b></td>";
                        } else {
                            if (rowss[i].hasOwnProperty("currentPrice")) {
                                html_text += "<td><b> $" + rowss[i].currentPrice.__value__ + "</b></td>";
                            } else {
                                html_text += "<td><b> $" + rowss[i].buyItNowPrice.__value__ + "</b></td>";
                            }
                        }
                    }
                    html_text += "</tr>";
                }
                html_text += "</table>";
                document.getElementById("similar_button").innerHTML =
                    "<a href='javaScript:void(0)' onclick='show_similar(" + itemid + "," + has_massage +
                    ")'><img src='arrow-up.png' width='40px'></a>";
                document.getElementById("similar_page").style.display = "";
                document.getElementById("similar_page").style.border = "2px solid lightgray";
                document.getElementById("seller_page").style.display = "none";
                document.getElementById("seller_button").innerHTML = "<a href='javaScript:void(0)' onclick='show_message(" +
                    itemid + "," + has_massage + ")'><img src='arrow-down.png' width='40px'></a>";
                document.getElementById("similar_page").innerHTML = html_text;
            } else {
                document.getElementById("similar_page").style.display = "none";
                document.getElementById("similar_page").innerHTML = "";
                document.getElementById("similar_page").style.border = "none";
                document.getElementById("similar_button").innerHTML =
                    "<a href='javaScript:void(0)' onclick='show_similar(" + itemid + "," + has_massage +
                    ")'><img src='arrow-down.png' width='40px'></a>";
            }
        }
    </script>

</body>

</html> 