({
    init: function (cmp, event, helper) {
        // helper.getChartofProductFamily(cmp, event, helper);
        var colorArray = [
            '#bfc2ff', '#015659', '#c1fffd', '#016d6d', '#a0cdef',
            '#b8b0f2', '#6780ef', '#999966', '#1809bf', '#7f9ed8', 
            '#278c9b', '#51cdd3', '#bed8be', '#cb9afc', '#9afc9a', 
            '#a550fa', '#7d07f2', '#9acbfc', '#df7307', ' #f8f829', 
            '#2929f8', '#f89129', '#7ef307', '#FF6633', '#FFB399', 
            '#FF33FF', '#FFFF99', '#00B3E6',
            '#E6B333', '#3366E6', '#999966', '#99FF99', '#B34D4D',
            '#80B300', '#809900', '#E6B3B3', '#6680B3', '#66991A',
            '#FF99E6', '#CCFF1A', '#FF1A66', '#E6331A', '#33FFCC',
            '#66994D', '#B366CC', '#4D8000', '#B33300', '#CC80CC',
            '#66664D', '#991AFF', '#E666FF', '#4DB3FF', '#1AB399',
            '#E666B3', '#33991A', '#CC9999', '#B3B31A', '#00E680',
            '#4D8066', '#809980', '#E6FF80', '#1AFF33', '#999933',
            '#FF3380', '#CCCC00', '#66E64D', '#4D80CC', '#9900B3',
            '#E64D66', '#4DB380', '#FF4D4D', '#99E6E6', '#6666FF'];
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        var lst6MonthName = [];
        var lst6MonthNumber = [];
        var d;
        var today = new Date();
        // for (var i = 6; i > 0; i--) {
        //     d = new Date(today.getFullYear(), today.getMonth() + 1 - i, 1);
        //     list6Month.push(months[d.getMonth()]);
        //     console.log(i)
        // }
        // console.log(JSON.stringify(list6Month));
        var lstLabelsChartProductShow = [];
        var lstLabelsChartProduct = [];
        var lstDataChartProduct = [];
        var lstDataChartRevenue = [];
        var lstLabelsChartRevenue = [];
        var lstColor = [];
        var actionGetChartProfuct = cmp.get("c.getChartofProductFamily");
        var getChartRevenue6Month = cmp.get("c.getChartofRevenue6Month");
        var month = new Date().getMonth() + 1;
        var year = new Date().getFullYear();
        actionGetChartProfuct.setParams({
            'AccountId': cmp.get("v.recordId")
        })
        actionGetChartProfuct.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                //go to next helper function to assign value to chart
                for (var i = 0; i < res.length; i++) {
                    lstLabelsChartProduct.push(res[i].Name);
                    lstDataChartProduct.push(res[i].expr0);
                    // lstColor.push(colorArray[Math.floor(Math.random() * colorArray.length)]);
                    lstColor.push(colorArray[i]);
                }
                console.log(res.length);
                if (res.length == 1) {
                    lstLabelsChartProductShow.push(res[0].Name);
                } else if (res.length >= 2) {
                    lstLabelsChartProductShow.push(res[0].Name);
                    lstLabelsChartProductShow.push(res[1].Name);
                }
                cmp.set('v.lstLabelsChartProductShow', lstLabelsChartProductShow);
                cmp.set('v.lstLabelsChartProduct', lstLabelsChartProduct);
                cmp.set('v.lstDataChartProduct', lstDataChartProduct);
                cmp.set('v.lstColor', lstColor);
            }
        });
        getChartRevenue6Month.setParams({
            'AccountId': cmp.get("v.recordId")
        })
        getChartRevenue6Month.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                // if (res[length - 1] == month) {
                //     for ()
                // }
                //go to next helper function to assign value to chart
                // for (var i = 0; i < res.length; i++) {
                //     // lstLabelsChartRevenue.push(res[i].expr1 + '/' + res[i].expr2);
                //     // lstDataChartRevenue.push(res[i].expr0);
                //     // lstColor.push(colorArray[i]);
                // }
                // for(var j=0; i< res)
                for (var i = 6; i > 0; i--) {
                    d = month + 1 - i;
                    lst6MonthName.push(months[d - 1]);
                    lst6MonthNumber.push(d);
                }
                for (var i = 0; i < lst6MonthNumber.length; i++) {
                    var price = 0;
                    var exists = res.find(function (number, index) {
                        if (number.expr1 == lst6MonthNumber[i]) {
                            price = res[index].expr0;
                        }
                        return number.expr1 == lst6MonthNumber[i];
                    });
                    if (exists == undefined) {
                        lstDataChartRevenue.push(0);
                    } else {
                        lstDataChartRevenue.push(price);
                    }
                }
                // for (var i = 6; i > 0; i--) {
                //     // d = new Date(today.getFullYear(), today.getMonth() + 1 - i, 1);
                //     console.log(months[d.getMonth()]);
                //     // console.log(d.getMonth());
                //     for (var j = 0; j < res.length; j++) {
                //         if (res[j].expr1 != months[d.getMonth()]) {
                //             console.log(d.getMonth());
                //             lstDataChartRevenue.push(0);
                //         } else {
                //             lstDataChartRevenue.push(res[j].expr0);
                //         }
                //         list6Month.push(months[d.getMonth()]);
                //     }
                //     // console.log(i)
                // }
                cmp.set('v.lstLabelsChartRevenue', lst6MonthName);
                cmp.set('v.lstDataChartRevenue', lstDataChartRevenue);
                // cmp.set('v.lstColor', lstColor);
            }
        });

        $A.enqueueAction(actionGetChartProfuct);
        $A.enqueueAction(getChartRevenue6Month);
    },

    scriptsLoaded: function (cmp, event, helper) {
        function getLabelsOnlyTopX(num, data, labels) {
            console.log(12345);
            var selectedLabels = []

            //we don't want to alter the order
            var helperData = [...data];

            //sort in descending order
            helperData.sort((a, b) => b - a);

            //get top X Values
            helperData = helperData.slice(0, num);

            //get index for the data
            var indexes = data.map((value, index) => ({ value, index })).filter(item => helperData.some(n1 => n1 == item.value))

            //slecet only labels with the correct index  
            selectedLabels = labels.filter((value, index) => indexes.some(n => n.index == index))

            // just be sure that a maximum of num labels are sent
            return selectedLabels.slice(0, num);
        }
        setTimeout(function () {
            Chart.defaults.font.size = 16;
            var ctx = cmp.find("myChart").getElement();
            var ctx1 = cmp.find("myChart1").getElement();
            if (cmp.myChart != null) {
                cmp.myChart.destroy();
            }
            if (cmp.myChart1 != null) {
                cmp.myChart1.destroy();
            }
            var data = {
                labels: cmp.get('v.lstLabelsChartProduct'),
                datasets: [
                    {
                        label: 'Total Payment',
                        backgroundColor: cmp.get('v.lstColor'),
                        data: cmp.get('v.lstDataChartProduct')
                    },
                ]
            }
            var maxLabelsToShow = 2;
            var showOnly = getLabelsOnlyTopX(maxLabelsToShow, cmp.get('v.lstDataChartProduct'), cmp.get('v.lstLabelsChartProduct'));
            cmp.myChart = new Chart(ctx, {
                type: 'doughnut',
                data: data,
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            align: 'start',
                            labels: {
                                usePointStyle: true,
                                filter: function (item, chart) {
                                    return showOnly.indexOf(item.text) > -1;
                                }
                            },
                        },
                        title: {
                            display: true,
                            text: 'Product Family',
                            align: 'start',
                            size: 17
                        }
                    },
                }
            });
            var data1 = {
                // labels: cmp.get('v.lstLabelsChartRevenue'),
                labels: cmp.get('v.lstLabelsChartRevenue'),
                datasets: [
                    {
                        label: 'Total Payment',
                        // backgroundColor: cmp.get('v.lstColor'),
                        // borderColor: 'rgb(245, 66, 138)',
                        backgroundColor: '#77CCFF',
                        data: cmp.get('v.lstDataChartRevenue')
                    },
                ]
            }

            cmp.myChart1 = new Chart(ctx1, {
                type: 'bar',
                data: data1,
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        },
                        title: {
                            display: true,
                            text: 'Order History',
                            align: 'start',
                            size: 13
                        }
                    },
                    scales: {
                        y: {
                            min: 0,
                            ticks: {
                                color: 'black',
                                beginAtZero: true,
                                callback: function (value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                // stepSize: 2000000
                            },
                            grid: {
                                drawOnChartArea: false
                            },
                            // stackWeight: 1
                        },
                        x: {
                            ticks: {
                                color: 'black',
                                beginAtZero: true
                            },
                            grid: {
                                drawOnChartArea: false
                            },
                        }
                    },
                },
            });
            // cmp.myChart1.destroy();
        }, 1500)

    }
})