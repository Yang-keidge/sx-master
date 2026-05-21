
<template>
    <div class="navbar">
        <div class="title-menu">
            <el-image v-if="heads.headTitleImg" class="title-img" :style="{width:heads.headTitleImgWidth,height:heads.headTitleImgHeight,boxShadow:heads.headTitleImgBoxShadow,borderRadius:heads.headTitleImgBorderRadius}" :src="heads.headTitleImgUrl" fit="cover"></el-image>
            <div class="title-name">{{this.$project.projectName}}</div>
        </div>
        <div class="right-menu">
            <div class="user-info">{{this.$storage.get('role')}} {{this.$storage.get('adminName')}}</div>
            <div class="logout" @click="onLogout">退出登录</div>
        </div>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                dialogVisible: false,
                ruleForm: {},
                user: {},
                heads: {"headLogoutFontHoverColor":"#252540","headFontSize":"25px","headUserInfoFontColor":"rgba(231, 231, 231, 1)","headBoxShadow":"0px 0px 0px 10px #FFFF66","headTitleImgHeight":"44px","headLogoutFontHoverBgColor":"rgba(42, 42, 69, 0.41)","headFontColor":"#e8eaf6","headTitleImg":false,"headHeight":"70px","headTitleImgBorderRadius":"22px","headTitleImgUrl":"http://codegen.caihongy.cn/20201021/cc7d45d9c8164b58b18351764eba9be1.jpg","headBgColor":"#64b5f6","headTitleImgBoxShadow":"0 1px 6px #444","headLogoutFontColor":"rgba(231, 231, 231, 1)","headUserInfoFontSize":"16px","headTitleImgWidth":"44px","headTitleStyle":"2","headLogoutFontSize":"16px"},
            };
        },
        created() {
            this.setHeaderStyle()
        },
        mounted() {
            let sessionTable = this.$storage.get("sessionTable")
            this.$http({
                url: sessionTable + '/session',
                method: "get"
            }).then(({
                         data
                     }) => {
                if (data && data.code === 0) {
                    this.user = data.data;
                } else {
                    let message = this.$message
                    message.error(data.msg);
                }
            });
        },
        methods: {
            onLogout() {
                let storage = this.$storage
                let router = this.$router
                storage.clear()
                router.replace({
                    name: "login"
                });
            },
            onIndexTap(){
                window.location.href = `${this.$base.indexUrl}`
            },
            setHeaderStyle() {
                this.$nextTick(()=>{
                    document.querySelectorAll('.navbar .right-menu .logout').forEach(el=>{
                        el.addEventListener("mouseenter", e => {
                            e.stopPropagation()
                            el.style.backgroundColor = this.heads.headLogoutFontHoverBgColor
                            el.style.color = this.heads.headLogoutFontHoverColor
                        })
                        el.addEventListener("mouseleave", e => {
                            e.stopPropagation()
                            el.style.backgroundColor = "transparent"
                            el.style.color = this.heads.headLogoutFontColor
                        })
                    })
                })
            },
        }
    };
</script>


<style lang="scss" scoped>
    .navbar {
        height: 60px;
        line-height: 60px;
        width: 100%;
        padding: 0 34px;
        box-sizing: border-box;
        background-color: #1a1a2e;
        border-bottom: 1px solid #333355;
        position: relative;
        z-index: 111;

    .right-menu {
        position: absolute;
        right: 34px;
        top: 0;
        height: 100%;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        z-index: 111;

    .user-info {
        font-size: 16px;
        color: #6b7280;
        padding: 0 12px;
    }

    .logout {
        font-size: 16px;
        color: #6b7280;
        padding: 0 12px;
        cursor: pointer;
        border-radius: 4px;
        transition: all 0.3s;

        &:hover {
            color: #e8eaf6;
            background-color: #2a2a45;
        }
    }

    }

    .title-menu {
        display: flex;
        justify-content: flex-start;
        align-items: center;
        width: 100%;
        height: 100%;

    .title-img {
        width: 44px;
        height: 44px;
        border-radius: 22px;
        box-shadow: 0 1px 6px #444;
        margin-right: 16px;
    }

    .title-name {
        font-size: 24px;
        color: #e8eaf6;
        font-weight: 700;
    }
    }
    }
</style>
