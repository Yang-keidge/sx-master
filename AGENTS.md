# AGENTS.md

## Project Overview

Graduate internship & employment management system (毕业生实习与就业管理系统). Single-repo, monolithic Spring Boot + embedded Vue 2 app.

## Structure

- **Backend**: `biyeshengshixiyujiuye/` — Maven, Java 8, Spring Boot 2.2.2
- **Frontend**: `biyeshengshixiyujiuye/src/main/resources/admin/admin/` — Vue 2 + Element UI + ECharts
- **DB init**: `db.sql` at repo root — creates database `biyeshengshixiyujiuye` with seed data

## Commands

### Backend
```bash
cd biyeshengshixiyujiuye
mvn clean package          # build
mvn spring-boot:run        # run (port 8080)
```

### Frontend
```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
cnpm install               # install deps (uses cnpm, not npm/yarn)
cnpm run serve             # dev server on port 8081, proxies /biyeshengshixiyujiuye to localhost:8080
cnpm run build             # production build -> dist/
```

## Database Setup

1. MySQL 5.7+ required. Create DB and seed:
   ```bash
   mysql -u root -p < db.sql
   ```
2. Default connection: `localhost:3306/biyeshengshixiyujiuye`, user `root`, password `123456` (configured in `application.yml`)
3. Default admin login: username `admin`, password `admin`

## Architecture Notes

- **Context path**: `/biyeshengshixiyujiuye` — all API paths are prefixed with this
- **Auth**: Custom `AuthorizationInterceptor` reads `Token` header. Annotate endpoints with `@IgnoreAuth` to skip auth. Sessions store `userId`, `role`, `tableName`, `username`
- **MyBatis-Plus**: Uses legacy 2.x API (`EntityWrapper`, `Wrapper`) — do not use 3.x `LambdaQueryWrapper`
- **ORM**: Entity classes in `com.entity`, VO/Model/View variants per entity. Mapper XMLs in `src/main/resources/mapper/`
- **Dictonary system**: `DictionaryEntity` + `DictionaryServletContextListener` loads dict values into app scope on startup
- **File upload**: handled by `FileController`, stores to `static/upload/` with URLs like `/biyeshengshixiyujiuye/upload/...`
- **Baidu AI**: Face-matching feature requires `APIKey`/`SecretKey` configured in `config` DB table

## Domain Entities

| Table | Entity | Role |
|-------|--------|------|
| xuesheng | XueshengEntity | Student |
| laoshi | LaoshiEntity | Teacher |
| qiye | QiyeEntity | Enterprise |
| shixi | ShixiEntity | Internship record |
| jiuye | JiuyeEntity | Employment record |
| gonggao_laoshi | GonggaoLaoshiEntity | Teacher announcements |
| gonggao_qiye | GonggaoQiyeEntity | Enterprise announcements |
| dictionary | DictionaryEntity | Enum/dropdown values |
| users | UsersEntity | Admin |
| token | TokenEntity | Auth tokens |

## Key Conventions

- No test suite exists — there are no tests to run
- All passwords in seed data are `123456`; admin is `admin`/`admin`
- Chinese comments are used throughout the codebase
- Static resource serving covers `classpath:/resources/`, `/static/`, `/admin/`, `/img/`, `/front/`, `/public/`