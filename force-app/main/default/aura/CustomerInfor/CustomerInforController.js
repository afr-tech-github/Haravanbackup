({
    init: function (cmp, event, helper) {
        var actionGetAccount = cmp.get("c.getAccountInfo");
        var actionGetSalesChannels = cmp.get("c.getCharofSalesChannels");
        var lstLabelsChartSalesChannels = [];
        var lstDataChartSalesChannels = [];
        var customerAddress = '';
        actionGetAccount.setParams({
            'AccountId': cmp.get("v.recordId")
        })

        actionGetAccount.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                console.log(res);
                cmp.set('v.Account', res[0]);
                customerAddress += res[0].Default_Address__pr.Address_1__c;
                if(res[0].Districttext__c){
                    customerAddress += ', ' + res[0].Districttext__c;
                }
                if(res[0].Wardtext__c){
                    customerAddress += ', ' + res[0].Wardtext__c;
                }
                if(res[0].Provincetext__c){
                    customerAddress += ', ' + res[0].Provincetext__c;
                }
                cmp.set('v.customerAddress', customerAddress);
            } else if (state == "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                if (errors) {
                    toastEvent.setParams({
                        "type": 'error',
                        "title": "Error",
                        "message": 'Error'
                    });
                    toastEvent.fire();
                }
            }
        });
        actionGetSalesChannels.setParams({
            'AccountId': cmp.get("v.recordId")
        })

        actionGetSalesChannels.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                for(var key in res){
                    lstLabelsChartSalesChannels.push(key);
                    lstDataChartSalesChannels.push(res[key].expr0);
                }
                // for (var i = 0; i < res.length; i++) {
                //     // if (res[i].Sales_Channel__c == undefined) {
                //     //     lstLabelsChartSalesChannels.push('');
                //     // } else if (res[i].Sales_Channel__c == 'haravan_draft_order') {
                //     //     lstLabelsChartSalesChannels.push('draft');
                //     // } else {
                //     //     lstLabelsChartSalesChannels.push(res[i].Sales_Channel__c);
                //     // }
                //     // lstDataChartSalesChannels.push(res[i].expr0);
                //     console.log(res[i].)
                // }
                cmp.set('v.lstLabelsChartSalesChannels', lstLabelsChartSalesChannels);
                cmp.set('v.lstDataChartSalesChannels', lstDataChartSalesChannels);
                // cmp.set('v.Account', res[0]);
            } else if (state == "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                if (errors) {
                    toastEvent.setParams({
                        "type": 'error',
                        "title": "Error",
                        "message": 'Error'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(actionGetAccount);
        $A.enqueueAction(actionGetSalesChannels);
    },
    scriptsLoaded: function (cmp, event, helper) {
        setTimeout(function () {
            Chart.defaults.font.size = 16;
            if(cmp.myChart2 != null){
                cmp.myChart2.destroy();
            }
            // Chart.defaults.color = '#fff';
            var ctx2 = cmp.find("myChart2").getElement();
            var data2 = {
                labels: cmp.get('v.lstLabelsChartSalesChannels'),
                datasets: [
                    {
                        label: 'Total Payment',
                        // backgroundColor: cmp.get('v.lstColor'),
                        // borderColor: 'rgb(245, 66, 138)',
                        backgroundColor: '#1BF9FF',
                        data: cmp.get('v.lstDataChartSalesChannels')
                    }
                ]
            }

            cmp.myChart2 = new Chart(ctx2, {
                type: 'bar',
                data: data2,
                options: {
                    
                    indexAxis: 'y',
                    elements: {
                        bar: {
                            borderWidth: 2,
                        }
                    },
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false,
                        },
                    },
                    scales: {
                        y: {
                            ticks: {
                                color: 'white',
                                beginAtZero: true
                            },
                            grid: {
                                drawOnChartArea: false
                            },
                        },
                        x: {
                            ticks: {
                                color: 'white',
                                beginAtZero: true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                            },
                            grid: {
                                drawOnChartArea: false
                            },
                        }
                    },
                },
            });
            
        }, 1500)

    },
    onClickAccount: function (cmp, event) {
        var getAccountId = cmp.get("v.AccountId");
        var url = "/lightning/r/Account/" + getAccountId + "/view";
        window.open(url, "_self");
    },
})