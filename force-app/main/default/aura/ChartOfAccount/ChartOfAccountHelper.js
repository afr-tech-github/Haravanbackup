({
    getChartofProductFamily: function (cmp, event, helper) {
        var actionGetChartProfuct = cmp.get("c.getChartofProductFamily");
        console.log(cmp.get("v.recordId"));
        actionGetChartProfuct.setParams({
            'AccountId': cmp.get("v.recordId")
        })
        actionGetChartProfuct.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log(res)
                //go to next helper function to assign value to chart
                this.setData(cmp, event, res);
            }
        });

        $A.enqueueAction(actionGetChartProfuct);
    },

    setData: function (cmp, event, res) {
        console.log('12345:' + JSON.stringify(res));
        var lstLabelsChart = [];
        var lstDataChart = [];
        for(var i = 0; i< res.length; i++){
            lstLabelsChart.push(res[i].expr0);
            lstDataChart.push(res[i].Name);
        }
        console.log(JSON.stringify(lstLabelsChart));
        console.log(JSON.stringify(lstDataChart));
        console.log(cmp.myChart.datasets);
        // cmp.myChart.labels = lstLabelsChart;
        // cmp.myChart.labels.datasets[0].data = lstDataChart;
        // console.log(cmp.myChart);
        // cmp.myChart.update();
    },
})