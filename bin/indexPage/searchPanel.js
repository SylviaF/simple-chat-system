(function() {
  define(function(require) {
    var SearchPanel, exports;
    SearchPanel = function() {
      this.all = $('.searchPanelContainer');
      this.closeBtn = $('.searchPanelContainer .closeBtn');
      this.inputForm = $('.searchPanelContainer .inputForm');
      this.searchResult = $('.searchPanelContainer .searchResult');
      this.email = $('.searchPanelContainer .semail');
      this.nick = $('.searchPanelContainer .snick');
      this.searchBtn = $('.searchPanelContainer .searchPanelBtn a');
      this.methodRadio = $('.searchPanelContainer input[name="method"]');
      this.method = 0;
      this.heading = $('.searchPanelContainer  .searchPanelContent h5');
      this.accurateIpt = $('.searchPanelContainer .inputs');
      return null;
    };
    SearchPanel.prototype = {
      init: function() {
        this.all.hide();
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        that.closeBtn.click(function() {
          console.log(1);
          that.all.hide();
          that.inputForm.show();
          that.searchResult.hide();
          that.email.val('');
          that.nick.val('');
          return that.heading.html('查找方式');
        });
        that.methodRadio.click(function() {
          that.method = parseInt($('input:radio[name="method"]:checked').val());
          if (!that.method) {
            return that.accurateIpt.show();
          } else {
            return that.accurateIpt.hide();
          }
        });
        return that.searchBtn.click(function() {
          return $.ajax({
            type: 'POST',
            url: '/api/getAccouts',
            data: {
              method: that.method,
              email: that.email.val(),
              nick: that.nick.val()
            },
            dataType: 'json',
            success: function(data) {
              if (!data.flag) {
                return console.log(data.err);
              } else {
                that.heading.html('查找结果');
                that.addUserList(data.result);
                that.inputForm.hide();
                that.searchResult.show();
                return console.log(data.result);
              }
            },
            error: function(err) {
              return console.log(err);
            }
          });
        });
      },
      addUserList: function(userList) {
        var classes, cls, i, user, _i, _len, _results;
        classes = ['odd', ''];
        this.searchResult.html('');
        _results = [];
        for (i = _i = 0, _len = userList.length; _i < _len; i = ++_i) {
          user = userList[i];
          cls = classes[i % 2];
          _results.push(this.addUserItem(user, cls));
        }
        return _results;
      },
      addUserItem: function(userItem, classname) {
        var array, item;
        array = ['<div class="findItem ' + classname + 'odd"><div class="info"><div class="nick">', userItem.nick, '</div><div class="second"><span>在线：</span><span class="isOnline">是</span></div><div class="second"><span>邮箱：</span><span class="email">', userItem.email, '</span></div></div><div class="btn">加为好友</div></div>'];
        item = array.join('');
        return this.searchResult.append(item);
      }
    };
    return exports = SearchPanel;
  });

}).call(this);
