/*!
 * 万户OA PC端 - 基于BootStrap深度定制
 */

/* jshint node: true */
module.exports = function(grunt) {
  'use strict';

  // Force use of Unix newlines
  grunt.util.linefeed = '\n';

  RegExp.quote = function(string) {
    return string.replace(/[-\\^$*+?.()|[\]{}]/g, '\\$&');
  };

  var buildTo = grunt.option('buildTo');
  var dist = buildTo ? (buildTo + '/') : 'defaultroot/dist/';

  //支持包含html
  //var connectSSI = require('connect-ssi');
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    // Metadata.
    meta: {
      name: 'OA-BootStrap',
      version: '0.1',
      distPath: dist,
      defaultroot: 'defaultroot/',
      docsPath: 'defaultroot/template/',
      sourcePath: 'defaultroot/source/',
      jsDistPath: 'defaultroot/scripts/static/',
      releasePath: 'release/',
      jsPath: 'defaultroot/source/bspjs/',
      lessPath: 'defaultroot/source/template/less/',
      fontsPath: 'defaultroot/source/template/fonts/',
      imagesPath: 'defaultroot/source/template/images/'
    },

    template: {
      tmpDefault: 'template_default',
      tmpSystem: 'template_system'
    },

    banner: '/*!\n' +
      ' * =====================================================\n' +
      ' * title:万户OA PC端 - 基于BootStrap深度定制\n' +
      ' * version: <%= pkg.version %>' +
      ' *\n' +
      ' * author: shionphan@126.com, 541951523@qq.com' +
      ' *\n' +
      ' * =====================================================\n' +
      ' */\n',

    clean: {
      dist: ['<%= meta.distPath %>', '<%= meta.docsPath %>']
    },

    concat: {
      bootstrap: {
        options: {
          banner: '<%= banner %>'
        },
        src: [
          '<%= meta.sourcePath %>/bspjs/bootstrap/transition.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/alert.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/button.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/carousel.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/collapse.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/dropdown.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/modal.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/tooltip.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/popover.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/scrollspy.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/tab.js',
          '<%= meta.sourcePath %>/bspjs/bootstrap/affix.js'
        ],
        dest: '<%= meta.jsDistPath %><%= pkg.name %>.js'
      },
      extend: {
        options: {
          banner: '<%= banner %>'
        },
        src: [
          //Lay弹框
          '<%= meta.sourcePath %>/bspjs/extend/layer.js',
          //日期选择器
          '<%= meta.sourcePath %>/bspjs/extend/laydate.js',
          //多功能下拉选单
          '<%= meta.sourcePath %>/bspjs/extend/chosen.js',
          //单功能下拉选单，支持响应式
          '<%= meta.sourcePath %>/bspjs/extend/select.js',
          //分页整合
          '<%= meta.sourcePath %>/bspjs/extend/pagination.js',
        ],
        dest: '<%= meta.jsDistPath %><%= pkg.name %>.extend.js'
      },
      custom: {
        options: {
          banner: '<%= banner %>'
        },
        src: [
          //监听设备
          '<%= meta.sourcePath %>/bspjs/custom/device.js',
          //返回顶部
          '<%= meta.sourcePath %>/bspjs/custom/scroll-top.js',
          //监听单击
          '<%= meta.sourcePath %>/bspjs/custom/active-status.js',
        ],
        dest: '<%= meta.jsDistPath %><%= pkg.name %>.custom.js'
      }
    },


    less: {
      options: {
        paths: ['./', '<%= meta.lessPath %>'],
        ieCompat: true
      },
      bootstrap: {
        // options: {
        //   strictMath: true,
        //   sourceMap: true,
        //   outputSourceFiles: true,
        //   sourceMapURL: '<%= pkg.name %>.bootstrap.css.map',
        //   sourceMapFilename: '<%= meta.distPath %>/css/<%= pkg.name %>.bootstrap.css.map'
        // },
        src: '<%= meta.lessPath %><%= pkg.name %>.bootstrap.less',
        dest: '<%= meta.distPath %>/css/<%= pkg.name %>.bootstrap.css'
      },
      fontless: {
        src: '<%= meta.lessPath %><%= pkg.name %>.fa.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.fa.css'
      },
      resetless: {
        src: '<%= meta.lessPath %><%= pkg.name %>.reset.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.reset.css'
      },
      printless: {
        src: '<%= meta.lessPath %><%= pkg.name %>.print.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.print.css'
      },
      media: {
        src: '<%= meta.lessPath %><%= pkg.name %>.media.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.media.css'
      },
      list: {
        src: '<%= meta.lessPath %><%= pkg.name %>.lists.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.lists.css'
      },
      core: {
        src: '<%= meta.lessPath %><%= pkg.name %>.style.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.style.css'
      },
      detail: {
        src: '<%= meta.lessPath %><%= pkg.name %>.detail.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.detail.css'
      },
      portal: {
        src: '<%= meta.lessPath %><%= pkg.name %>.portal.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.portal.css'
      },
      themesbefore: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.before.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.before.css'
      },
      themesafter: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.after.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.after.css'
      },
      themesline: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.line.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.line.css'
      },
      themesnewpure: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.newpure.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.newpure.css'
      },

      themeswidth: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.width.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.width.css'
      },
       themespro: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.pro.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.pro.css'
      },
      themesdetail: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.detail.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.detail.css'
      },
      themesmedia: {
        src: '<%= meta.lessPath %>/themes/2016/<%= pkg.name %>.theme.media.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.media.css'
      },
      stylesize: {
        src: '<%= meta.lessPath %><%= pkg.name %>.style.size.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.style.size.css'
      },
      portalsize: {
        src: '<%= meta.lessPath %><%= pkg.name %>.portal.size.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.portal.size.css'
      },
      detailize: {
        src: '<%= meta.lessPath %><%= pkg.name %>.detail.size.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.detail.size.css'
      },
      login: {
        src: '<%= meta.lessPath %><%= pkg.name %>.logins.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.logins.css'
      },
      login_12oa: {
        src: '<%= meta.lessPath %><%= pkg.name %>.logins_12oa.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.logins_12oa.css'
      },
      system: {
        src: '<%= meta.lessPath %>/system/<%= pkg.name %>.system.less',
        dest: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.system.css'
      },
    },

    usebanner: {
      dist: {
        options: {
          position: 'top',
          banner: '<%= banner %>'
        },
        files: {
          src: [
            '<%= meta.distPath %>/css/*.css'
          ]
        }
      }
    },

    cssmin: {
      options: {
        compatibility: 'ie8',
        keepSpecialComments: '*', // keep all important comments
        advanced: false
      },

      fontless: {
        src: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.fa.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.fa.min.css'
      },
      
      resetless: {
        src: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.reset.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.reset.min.css'
      },
      printless: {
        src: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.print.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.print.min.css'
      },
      media: {        
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.media.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.media.min.css'
      },
      list: {        
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.lists.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.lists.min.css'
      },
      core: {        
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.style.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.style.min.css'
      },
      detail: {        
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.detail.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.detail.min.css'
      },
      bootstrap: {
        src: '<%= meta.distPath %>/css/<%= pkg.name %>.bootstrap.css',
        dest: '<%= meta.docsPath %>/css/<%= pkg.name %>.bootstrap.min.css'
      },
      portal: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.portal.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.portal.min.css'
      },
      themesbefore: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.before.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.before.min.css'
      },
      themesafter: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.after.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.after.min.css'
      },
      themesline: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.line.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.line.min.css'
      },
      themesnewpure: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.newpure.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.newpure.min.css'
      },
      themeswidth: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.width.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.width.min.css'
      },
       themespro: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.pro.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.pro.min.css'
      },
      themesmedia: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.media.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.media.min.css'
      },
      themesdetail: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.detail.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/themes/2016/<%= pkg.name %>.theme.detail.min.css'
      },
      stylesize: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.style.size.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.style.size.min.css'
      },
      portalsize: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.portal.size.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.portal.size.min.css'
      },
      detailsize: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.detail.size.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.detail.size.min.css'
      },
      login: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.logins.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.logins.min.css'
      },
      login_12oa: {
        src: '<%= meta.distPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.logins_12oa.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpDefault %>/<%= pkg.name %>.logins_12oa.min.css'
      },
      // system: {
      //   src: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.system.css',
      //   dest: '<%= meta.docsPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.system.min.css'
      // },
      system: {
        src: '<%= meta.distPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.system.css',
        dest: '<%= meta.docsPath %>/css/<%= template.tmpSystem %>/<%= pkg.name %>.system.min.css'
      },
    },

    uglify: {
      options: {
        banner: '<%= banner %>',
        compress: {
          warnings: false
        },
        mangle: true,
        preserveComments: false
      },
      sm: {
        src: '<%= concat.bootstrap.dest %>',
        dest: '<%= meta.jsDistPath %><%= pkg.name %>.min.js'
      },
      extend: {
        src: '<%= concat.extend.dest %>',
        dest: '<%= meta.jsDistPath %><%= pkg.name %>.extend.min.js'
      },
      custom: {
        src: '<%= concat.custom.dest %>',
        dest: '<%= meta.jsDistPath %><%= pkg.name %>.custom.min.js'
      }
    },

    qunit: {
      options: {
        inject: 'js/tests/unit/phantom.js'
      },
      files: 'js/tests/index.html'
    },
    copy: {
      fonts: {
        flatten: true,
        expand: true,
        src: '<%= meta.sourcePath %>/template/fonts/*',
        dest: '<%= meta.distPath %>/fonts'
      },
      img: {
        expand: true,
        cwd: '<%= meta.sourcePath %>/template/images',
        src: ['**/*'],
        dest: '<%= meta.distPath %>/images'
      },
      tfonts: {
        flatten: true,
        expand: true,
        src: '<%= meta.sourcePath %>/template/fonts/*',
        dest: '<%= meta.docsPath %>/fonts'
      },
      timg: {
        expand: true,
        cwd: '<%= meta.sourcePath %>/template/images',
        src: ['**/*'],
        dest: '<%= meta.docsPath %>/images'
      }
    },
    watch: {
      options: {
        livereload: true,
      },
      scripts: {
        files: ['<%= meta.sourcePath %>/template/less/**/*.less'],
        tasks: ['less'],
        options: {
            spawn: false,
        },
      },
      detail: {
        files: ['<%= meta.sourcePath %>/template/less/style/template.detail.less'],
        tasks: ['less:detail'],
        options: {
            spawn: false,
        },
      },
    }
  });

  // 载入插件
  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  // 注册任务
  grunt.registerTask('dist-css', ['less', 'usebanner', 'cssmin']);
  // Build css
  grunt.registerTask('build-css', ['dist-css', 'cssmin']);
  // Build JS
  grunt.registerTask('dist-js', ['concat']);
  grunt.registerTask('build-js', ['dist-js', 'uglify']);
  // Build Dist 全局
  grunt.registerTask('dist', ['clean', 'build-css', 'build-js', 'copy']);
  grunt.registerTask('build', ['dist']);
  // 保存Media CSS任务和压缩
  grunt.registerTask('fal', ['less:fontless']);
  grunt.registerTask('savemedia', ['less:media','cssmin:media']);
  // 保存Core CSS任务和压缩
  grunt.registerTask('savecore', ['less:core','cssmin:core']);
  // 保存Bootstrap CSS任务和压缩
  grunt.registerTask('saveboot', ['less:bootstrap','cssmin:bootstrap']);
  // 保存主题 CSS任务和压缩
  grunt.registerTask('savetheme', ['less:themes','cssmin:themes']);
  // 保存字符大小 CSS任务和压缩
  grunt.registerTask('savesize', ['less:stylesize','cssmin:stylesize']);
  // 创建服务器环境 
  grunt.registerTask('server', ['connect:keepalive']);
  // 创建监听 
  grunt.registerTask('watchtsk', ['server','watch']);
  // 创建监听详情页
  grunt.registerTask('watchdtl', ['watch:detail']);
  // 创建Release
  grunt.registerTask('release', ['copy:tfonts','copy:timg','less','cssmin']);
  // 默认任务
  grunt.registerTask('default', ['build-js', 'build-css', 'copy']); 

  grunt.registerTask('css', ['build-css', 'copy']); 

};
