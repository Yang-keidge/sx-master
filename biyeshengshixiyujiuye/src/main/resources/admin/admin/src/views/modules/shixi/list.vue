<template>
    <div class="main-content">

        <div v-if="showFlag">
            <el-form :inline="true" :model="searchForm" class="form-content">
                <el-row :gutter="20" class="slt" :style="{justifyContent:contents.searchBoxPosition=='1'?'flex-start':contents.searchBoxPosition=='2'?'center':'flex-end'}">
                                                                         
                    <el-form-item :label="contents.inputTitle == 1 ? '企业名称' : ''">
                        <el-input prefix-icon="el-icon-search" v-model="searchForm.qiyeName" placeholder="企业名称" clearable></el-input>
                    </el-form-item>
                                                                                  
                    <el-form-item :label="contents.inputTitle == 1 ? '实习名称' : ''">
                        <el-input prefix-icon="el-icon-search" v-model="searchForm.shixiName" placeholder="实习名称" clearable></el-input>
                    </el-form-item>
         
                    <el-form-item :label="contents.inputTitle == 1 ? '实习类型' : ''">
                        <el-select v-model="searchForm.shixiTypes" placeholder="请选择实习类型">
                            <el-option label="=-请选择-=" value=""></el-option>
                            <el-option
                               v-for="(item,index) in shixiTypesSelectSearch"
                               v-bind:key="index"
                               :label="item.indexName"
                               :value="item.codeIndex">
                            </el-option>
                        </el-select>
                    </el-form-item>
                                                                                  
                    <el-form-item :label="contents.inputTitle == 1 ? '学生姓名' : ''">
                        <el-input prefix-icon="el-icon-search" v-model="searchForm.xueshengName" placeholder="学生姓名" clearable></el-input>
                    </el-form-item>

                    <el-form-item>
                        <el-button type="success" @click="search()">查询<i class="el-icon-search el-icon--right"/></el-button>
                    </el-form-item>
                </el-row>
                <el-row class="ad" :style="{justifyContent:contents.btnAdAllBoxPosition=='1'?'flex-start':contents.btnAdAllBoxPosition=='2'?'center':'flex-end'}">
                    <el-form-item>
                        <el-button v-if="isAuth('shixi','新增')" type="success" icon="el-icon-plus" @click="addOrUpdateHandler()">新增</el-button>
                        &nbsp;
                        <el-button v-if="isAuth('shixi','删除')" :disabled="dataListSelections.length <= 0" type="danger" icon="el-icon-delete" @click="deleteHandler()">删除</el-button>
                        &nbsp;
                        <el-button v-if="isAuth('shixi','报表')" type="success" icon="el-icon-pie-chart" @click="chartDialog()">报表</el-button>
                        &nbsp;
                        <a style="text-decoration:none" class="el-button el-button--success" v-if="isAuth('shixi','导入导出')" icon="el-icon-download" href="http://localhost:8080/biyeshengshixiyujiuye/upload/shixiMuBan.xls">批量导入实习信息数据模板</a>
                        &nbsp;
                        <el-upload v-if="isAuth('shixi','导入导出')" style="display: inline-block" action="biyeshengshixiyujiuye/file/upload" :on-success="shixiUploadSuccess" :on-error="shixiUploadError" :show-file-list = false>
                            <el-button v-if="isAuth('shixi','导入导出')" type="success" icon="el-icon-upload2">批量导入实习信息数据</el-button>
                        </el-upload>
                        &nbsp;
                        <download-excel v-if="isAuth('shixi','导入导出')" style="display: inline-block" class = "export-excel-wrapper" :data = "dataList" :fields = "json_fields" name = "shixi.xls">
                            <el-button type="success" icon="el-icon-download">导出</el-button>
                        </download-excel>
                        &nbsp;
                    </el-form-item>
                </el-row>
            </el-form>
            <div class="table-content">
                <el-table class="tables" :size="contents.tableSize" :show-header="contents.tableShowHeader" :header-row-style="headerRowStyle" :header-cell-style="headerCellStyle" :border="contents.tableBorder" :fit="contents.tableFit" :stripe="contents.tableStripe" :row-style="rowStyle" :cell-style="cellStyle" :style="{width: '100%',fontSize:contents.tableContentFontSize,color:contents.tableContentFontColor}" v-if="isAuth('shixi','查看')" :data="dataList" v-loading="dataListLoading" @selection-change="selectionChangeHandler">
                    <el-table-column v-if="contents.tableSelection" type="selection" header-align="center" align="center" width="50"></el-table-column>
                    <el-table-column label="索引" v-if="contents.tableIndex" type="index" width="50" />
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="qiyeName" header-align="center" label="企业名称">
                        <template slot-scope="scope">{{scope.row.qiyeName}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="qiyePhoto" header-align="center" width="200" label="企业图片">
                        <template slot-scope="scope">
                            <div v-if="scope.row.qiyePhoto"><img :src="scope.row.qiyePhoto" width="100" height="100"></div>
                            <div v-else>无图片</div>
                        </template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="shixiName" header-align="center" label="实习名称">
                        <template slot-scope="scope">{{scope.row.shixiName}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="shixiTypes" header-align="center" label="实习类型">
                        <template slot-scope="scope">{{scope.row.shixiValue}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="shixiKaishiTime" header-align="center" label="实习开始时间">
                        <template slot-scope="scope">{{scope.row.shixiKaishiTime}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="shixiJieshuTime" header-align="center" label="实习结束时间">
                        <template slot-scope="scope">{{scope.row.shixiJieshuTime}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="shixiJieguoTypes" header-align="center" label="实习结果">
                        <template slot-scope="scope">{{scope.row.shixiJieguoValue}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="shixiGangweiName" header-align="center" label="实习岗位">
                        <template slot-scope="scope">{{scope.row.shixiGangweiName}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="xueshengName" header-align="center" label="学生姓名">
                        <template slot-scope="scope">{{scope.row.xueshengName}}</template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="xueshengPhoto" header-align="center" width="200" label="学生头像">
                        <template slot-scope="scope">
                            <div v-if="scope.row.xueshengPhoto"><img :src="scope.row.xueshengPhoto" width="100" height="100"></div>
                            <div v-else>无图片</div>
                        </template>
                    </el-table-column>
                    <el-table-column :sortable="contents.tableSortable" :align="contents.tableAlign" prop="insertTime" header-align="center" label="录入时间">
                        <template slot-scope="scope">{{scope.row.insertTime}}</template>
                    </el-table-column>
                    <el-table-column width="300" :align="contents.tableAlign" header-align="center" label="操作">
                        <template slot-scope="scope">
                            <el-button v-if="isAuth('shixi','查看')" type="success" icon="el-icon-tickets" size="mini" @click="addOrUpdateHandler(scope.row.id,'info')">详情</el-button>
                            <el-button v-if="isAuth('shixi','修改')" type="primary" icon="el-icon-edit" size="mini" @click="addOrUpdateHandler(scope.row.id)">修改</el-button>
                            <el-button v-if="isAuth('shixi','删除')" type="danger" icon="el-icon-delete" size="mini" @click="deleteHandler(scope.row.id)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <el-pagination clsss="pages" :layout="layouts" @size-change="sizeChangeHandle" @current-change="currentChangeHandle" :current-page="pageIndex" :page-sizes="[10, 20, 50, 100]" :page-size="Number(contents.pageEachNum)" :total="totalPage" :small="contents.pageStyle" class="pagination-content" :background="contents.pageBtnBG" :style="{textAlign:contents.pagePosition==1?'left':contents.pagePosition==2?'center':'right'}"></el-pagination>
            </div>
        </div>
        <add-or-update v-if="addOrUpdateFlag" :parent="this" ref="add-or-update"></add-or-update>
        <el-dialog title="统计报表" :visible.sync="chartVisiable" width="800">
            <el-date-picker v-model="echartsDate" type="year" placeholder="选择年"></el-date-picker>
            <el-button @click="chartDialog()">查询</el-button>
            <div id="statistic" style="width:100%;height:600px;"></div>
            <span slot="footer" class="dialog-footer"><el-button @click="chartVisiable = false">关闭</el-button></span>
        </el-dialog>
    </div>
</template>
<script>
    import AddOrUpdate from "./add-or-update";
    import styleJs from "../../../utils/style.js";
    import utilsJs from "../../../utils/utils.js";

    export default {
        data() {
            return {
                searchForm: {
                    key: ""
                },
                sessionTable : "",
                role : "",
                userId:"",
                shixiTypesSelectSearch : [],
                form:{
                    id : null,
                    xueshengId : null,
                    qiyeId : null,
                    shixiName : null,
                    shixiTypes : null,
                    shixiKaishiTime : null,
                    shixiJieshuTime : null,
                    shixiJieguoTypes : null,
                    shixiGangweiName : null,
                    shixiContent : null,
                    insertTime : null,
                    createTime : null,
                },
                dataList: [],
                pageIndex: 1,
                pageSize: 10,
                totalPage: 0,
                dataListLoading: false,
                dataListSelections: [],
                showFlag: true,
                sfshVisiable: false,
                shForm: {},
                chartVisiable: false,
                echartsDate: new Date(),
                addOrUpdateFlag:false,
                contents:null,
                layouts: '',
                json_fields: {
                    '企业名称': 'qiyeName',
                    '企业图片': 'qiyePhoto',
                    '企业联系方式': 'qiyePhone',
                    '企业邮箱': 'qiyeEmail',
                    '实习名称': "shixiName",
                    '实习类型': "shixiTypes",
                    '实习开始时间': "shixiKaishiTime",
                    '实习结束时间': "shixiJieshuTime",
                    '实习结果': "shixiJieguoTypes",
                    '实习岗位': "shixiGangweiName",
                    '学生姓名': 'xueshengName',
                    '学生手机号': 'xueshengPhone',
                    '学生身份证号': 'xueshengIdNumber',
                    '学生头像': 'xueshengPhoto',
                    '电子邮箱': 'xueshengEmail',
                    '录入时间': "insertTime",
                },
            };
        },
        created() {
            this.contents = styleJs.listStyle();
            this.init();
            this.getDataList();
            this.contentStyleChange()
        },
        mounted() {
            this.sessionTable = this.$storage.get("sessionTable");
            this.role = this.$storage.get("role");
            this.userId = this.$storage.get("userId");
        },
        filters: {
            htmlfilter: function (val) {
                return val.replace(/<[^>]*>/g).replace(/undefined/g,'');
            }
        },
        components: {
            AddOrUpdate,
        },
        computed: {
        },
        methods: {
            chartDialog() {
                let _this = this;
                let params = {
                    dateFormat :"%Y",
                    riqi :_this.echartsDate.getFullYear(),
                    thisTable : {
                        tableName :'shixi',
                        sumColum : 'shixi_number',
                        date : 'insert_time',
                    }
                }
                _this.chartVisiable = true;
                _this.$nextTick(() => {
                    var statistic = this.$echarts.init(document.getElementById("statistic"), 'macarons');
                    this.$http({
                        url: "barSum",
                        method: "get",
                        params: params
                    }).then(({data}) => {
                        if(data && data.code === 0){
                            let yAxisName = "数值";
                            let xAxisName = "月份";
                            let series = [];
                            data.data.yAxis.forEach(function (item,index) {
                                let tempMap = {};
                                tempMap.name=data.data.legend[index];
                                tempMap.type='bar';
                                tempMap.data=item;
                                series.push(tempMap);
                            })
                            var option = {
                                tooltip: {
                                    trigger: 'axis',
                                    axisPointer: {
                                        type: 'cross',
                                        crossStyle: {
                                            color: '#999'
                                        }
                                    }
                                },
                                toolbox: {
                                    feature: {
                                        magicType: { show: true, type: ['line', 'bar'] },
                                        saveAsImage: { show: true }
                                    }
                                },
                                legend: {
                                    data: data.data.legend
                                },
                                xAxis: [
                                    {
                                        type: 'category',
                                        name: xAxisName,
                                        data: data.data.xAxis,
                                        axisPointer: {
                                            type: 'shadow'
                                        }
                                    }
                                ],
                                yAxis: [
                                    {
                                        type: 'value',
                                        name: yAxisName,
                                        axisLabel: {
                                            formatter: '{value}'
                                        }
                                    }
                                ],
                                series:series
                            };
                            statistic.setOption(option,true);
                            window.onresize = function () {
                                statistic.resize();
                            };
                        }else {
                            this.$message({
                                message: "报表未查询到数据",
                                type: "success",
                                duration: 1500,
                                onClose: () => {
                                    this.search();
                                }
                            });
                        }
                    });
                });
            },
            contentStyleChange() {
                this.contentSearchStyleChange()
                this.contentBtnAdAllStyleChange()
                this.contentSearchBtnStyleChange()
                this.contentTableBtnStyleChange()
                this.contentPageStyleChange()
            },
            contentSearchStyleChange() {
                this.$nextTick(() => {
                    document.querySelectorAll('.form-content .slt .el-input__inner').forEach(el => {
                        let textAlign = 'left'
                        if(this.contents.inputFontPosition == 2)
                            textAlign = 'center'
                        if (this.contents.inputFontPosition == 3) textAlign = 'right'
                        el.style.textAlign = textAlign
                        el.style.height = this.contents.inputHeight
                        el.style.lineHeight = this.contents.inputHeight
                        el.style.color = this.contents.inputFontColor
                        el.style.fontSize = this.contents.inputFontSize
                        el.style.borderWidth = this.contents.inputBorderWidth
                        el.style.borderStyle = this.contents.inputBorderStyle
                        el.style.borderColor = this.contents.inputBorderColor
                        el.style.borderRadius = this.contents.inputBorderRadius
                        el.style.backgroundColor = this.contents.inputBgColor
                    })
                    if (this.contents.inputTitle) {
                        document.querySelectorAll('.form-content .slt .el-form-item__label').forEach(el => {
                            el.style.color = this.contents.inputTitleColor
                            el.style.fontSize = this.contents.inputTitleSize
                            el.style.lineHeight = this.contents.inputHeight
                        })
                    }
                    setTimeout(() => {
                        document.querySelectorAll('.form-content .slt .el-input__prefix').forEach(el => {
                            el.style.color = this.contents.inputIconColor
                            el.style.lineHeight = this.contents.inputHeight
                        })
                        document.querySelectorAll('.form-content .slt .el-input__suffix').forEach(el => {
                            el.style.color = this.contents.inputIconColor
                            el.style.lineHeight = this.contents.inputHeight
                        })
                        document.querySelectorAll('.form-content .slt .el-input__icon').forEach(el => {
                            el.style.lineHeight = this.contents.inputHeight
                        })
                    }, 10 )
                })
            },
            contentSearchBtnStyleChange() {
                this.$nextTick(() => {
                    document.querySelectorAll('.form-content .slt .el-button--success').forEach(el => {
                        el.style.height = this.contents.searchBtnHeight
                        el.style.color = this.contents.searchBtnFontColor
                        el.style.fontSize = this.contents.searchBtnFontSize
                        el.style.borderWidth = this.contents.searchBtnBorderWidth
                        el.style.borderStyle = this.contents.searchBtnBorderStyle
                        el.style.borderColor = this.contents.searchBtnBorderColor
                        el.style.borderRadius = this.contents.searchBtnBorderRadius
                        el.style.backgroundColor = this.contents.searchBtnBgColor
                    })
                })
            },
            contentBtnAdAllStyleChange() {
                this.$nextTick(() => {
                    document.querySelectorAll('.form-content .ad .el-button--success').forEach(el => {
                        el.style.height = this.contents.btnAdAllHeight
                        el.style.color = this.contents.btnAdAllAddFontColor
                        el.style.fontSize = this.contents.btnAdAllFontSize
                        el.style.borderWidth = this.contents.btnAdAllBorderWidth
                        el.style.borderStyle = this.contents.btnAdAllBorderStyle
                        el.style.borderColor = this.contents.btnAdAllBorderColor
                        el.style.borderRadius = this.contents.btnAdAllBorderRadius
                        el.style.backgroundColor = this.contents.btnAdAllAddBgColor
                    })
                    document.querySelectorAll('.form-content .ad .el-button--danger').forEach(el => {
                        el.style.height = this.contents.btnAdAllHeight
                        el.style.color = this.contents.btnAdAllDelFontColor
                        el.style.fontSize = this.contents.btnAdAllFontSize
                        el.style.borderWidth = this.contents.btnAdAllBorderWidth
                        el.style.borderStyle = this.contents.btnAdAllBorderStyle
                        el.style.borderColor = this.contents.btnAdAllBorderColor
                        el.style.borderRadius = this.contents.btnAdAllBorderRadius
                        el.style.backgroundColor = this.contents.btnAdAllDelBgColor
                    })
                    document.querySelectorAll('.form-content .ad .el-button--warning').forEach(el => {
                        el.style.height = this.contents.btnAdAllHeight
                        el.style.color = this.contents.btnAdAllWarnFontColor
                        el.style.fontSize = this.contents.btnAdAllFontSize
                        el.style.borderWidth = this.contents.btnAdAllBorderWidth
                        el.style.borderStyle = this.contents.btnAdAllBorderStyle
                        el.style.borderColor = this.contents.btnAdAllBorderColor
                        el.style.borderRadius = this.contents.btnAdAllBorderRadius
                        el.style.backgroundColor = this.contents.btnAdAllWarnBgColor
                    })
                })
            },
            rowStyle({row, rowIndex}) {
                if (rowIndex % 2 == 1) {
                    if (this.contents.tableStripe) {
                        return {color: this.contents.tableStripeFontColor}
                    }
                } else {
                    return ''
                }
            },
            cellStyle({row, rowIndex}) {
                if (rowIndex % 2 == 1) {
                    if (this.contents.tableStripe) {
                        return {backgroundColor: this.contents.tableStripeBgColor}
                    }
                } else {
                    return ''
                }
            },
            headerRowStyle({row, rowIndex}) {
                return {color: this.contents.tableHeaderFontColor}
            },
            headerCellStyle({row, rowIndex}) {
                return {backgroundColor: this.contents.tableHeaderBgColor}
            },
            contentTableBtnStyleChange() {
            },
            contentPageStyleChange() {
                let arr = []
                if (this.contents.pageTotal) arr.push('total')
                if (this.contents.pageSizes) arr.push('sizes')
                if (this.contents.pagePrevNext) {
                    arr.push('prev')
                    if (this.contents.pagePager) arr.push('pager')
                    arr.push('next')
                }
                if (this.contents.pageJumper) arr.push('jumper')
                this.layouts = arr.join()
                this.contents.pageEachNum = 10
            },

            init() {
            },
            search() {
                this.pageIndex = 1;
                this.getDataList();
            },
            getDataList() {
                this.dataListLoading = true;
                let params = {
                    page: this.pageIndex,
                    limit: this.pageSize,
                    sort: 'id',
                }

                if (this.searchForm.qiyeName!= '' && this.searchForm.qiyeName!= undefined) {
                    params['qiyeName'] = '%' + this.searchForm.qiyeName + '%'
                }
                if (this.searchForm.shixiName!= '' && this.searchForm.shixiName!= undefined) {
                    params['shixiName'] = '%' + this.searchForm.shixiName + '%'
                }
                if (this.searchForm.shixiTypes!= '' && this.searchForm.shixiTypes!= undefined) {
                    params['shixiTypes'] = this.searchForm.shixiTypes
                }
                if (this.searchForm.xueshengName!= '' && this.searchForm.xueshengName!= undefined) {
                    params['xueshengName'] = '%' + this.searchForm.xueshengName + '%'
                }
                params['shixiDelete'] = 1

                this.$http({
                    url: "shixi/page",
                    method: "get",
                    params: params
                }).then(({data}) => {
                    if(data && data.code === 0){
                        this.dataList = data.data.list;
                        this.totalPage = data.data.total;
                    }else{
                        this.dataList = [];
                        this.totalPage = 0;
                    }
                    this.dataListLoading = false;
                });

                this.$http({
                    url: "dictionary/page?dicCode=shixi_types&page=1&limit=100",
                    method: "get",
                    page: 1,
                    limit: 100,
                }).then(({data}) => {
                    if(data && data.code === 0){
                        this.shixiTypesSelectSearch = data.data.list;
                    }
                });
            },
            sizeChangeHandle(val) {
                this.pageSize = val;
                this.pageIndex = 1;
                this.getDataList();
            },
            currentChangeHandle(val) {
                this.pageIndex = val;
                this.getDataList();
            },
            selectionChangeHandler(val) {
                this.dataListSelections = val;
            },
            addOrUpdateHandler(id, type) {
                this.showFlag = false;
                this.addOrUpdateFlag = true;
                this.crossAddOrUpdateFlag = false;
                if (type != 'info') {
                    type = 'else';
                }
                this.$nextTick(() => {
                    this.$refs.addOrUpdate.init(id, type);
                });
            },
            download(file) {
                window.open(`${file}`)
            },
            deleteHandler(id) {
                var ids = id ? [Number(id)] : this.dataListSelections.map(item => {
                    return Number(item.id);
                });

                this.$confirm(`确定进行[${id ? "删除" : "批量删除"}]操作?`, "提示", {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning"
                }).then(() => {
                    this.$http({
                        url: "shixi/delete",
                        method: "post",
                        data: ids
                    }).then(({data}) => {
                        if(data && data.code === 0){
                            this.$message({
                                message: "操作成功",
                                type: "success",
                                duration: 1500,
                                onClose: () => {
                                    this.search();
                                }
                            });
                        }else{
                            this.$message.error(data.msg);
                        }
                    });
                });
            },
            shixiUploadSuccess(data){
                let _this = this;
                _this.$http({
                    url: "shixi/batchInsert?fileName=" + data.file,
                    method: "get"
                }).then(({data}) => {
                    if(data && data.code === 0){
                        _this.$message({
                            message: "导入实习信息数据成功",
                            type: "success",
                            duration: 1500,
                            onClose: () => {
                                _this.search();
                            }
                        });
                    }else{
                        _this.$message.error(data.msg);
                    }
                });
            },
            shixiUploadError(data){
                this.$message.error('上传失败');
            },
        }
    };
</script>
<style lang="scss" scoped>
.slt { margin: 0 !important; display: flex; }
.ad { margin: 0 !important; display: flex; }
.pages { &::v-deep el-pagination__sizes{ &::v-deep el-input__inner { height: 22px; line-height: 22px; } } }
.el-button+.el-button { margin:0; }
.tables {
	&::v-deep .el-button--success { height: 40px; color: rgba(88, 84, 84, 1); font-size: 10px; border-width: 1px; border-style: solid; border-color: #DCDFE6; border-radius: 20px; background-color: rgba(153, 204, 51, 1); }
	&::v-deep .el-button--primary { height: 40px; color: rgba(91, 87, 87, 1); font-size: 10px; border-width: 1px; border-style: solid; border-color: #DCDFE6; border-radius: 20px; background-color: rgba(255, 255, 102, 1); }
	&::v-deep .el-button--danger { height: 40px; color: rgba(255, 255, 255, 1); font-size: 10px; border-width: 1px; border-style: solid; border-color: #DCDFE6; border-radius: 20px; background-color: rgba(51, 102, 0, 1); }
    &::v-deep .el-button { margin: 4px; }
}
</style>