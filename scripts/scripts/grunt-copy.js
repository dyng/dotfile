module.exports = function(grunt) {
  var source = 'from/' + '**/*';
  var dest = 'to/';

  grunt.initConfig({
    watch: {
      main: {
        files: [],
        tasks: ['copy:main']
      }
    },
    copy: {
      main: {
        files: [
          {
            expand: true,
            src: [source],
            dest: dest,
            filter: 'isFile'
          },
        ]
      }
    }
  })
}
