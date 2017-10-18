
import UIKit
import WebKit

// main viewcontroller
// NOTE:
//  this currently also acts as the delegate for the textView, tableView and webView,
//  would be nicer to give them their own class. (this code is way too long
//  and unstructured at the moment)

class ViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate {
    
    // @IBOutlets
    @IBOutlet weak var codeField: UITextView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var projectMenu: UIView!
    @IBOutlet weak var projectTable: UITableView!
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    // default js and html strings
    var js:String = "function setup() {\n\tcreateCanvas(400,400);\n}\n\nfunction draw() {\n\tbackground(0);\n}";
    var html:String = "<html>\n\t<head>\n\t\t<script src='https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.16/p5.js'></script>\n\t\t<script src='https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.16/addons/p5.dom.js'></script>\n\t\t<script src='sketch.js'></script>\n\t</head>\n\t<body>\n\t</body>\n</html>";
    var projectname = "Project 1";
    
    var mode:String = "js";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if there are projects in memory
        if (core.returnNames().count == 0) {
            // if not, use default js and html strings
            codeField.text = js
            save()
        } else {
            // if there is, load the first one
            projectname = core.returnNames()[0];
            load()
        }
        
        codeField.delegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        syntaxHighlighting(codeField: self.codeField,  mode: mode, line: -1, reset: true)
    }
    
    @IBAction func projectMenu_clicked(_ sender: UIButton) {
        if (isIphone()) {
            view.endEditing(true)
        }
        if (projectMenu.isHidden) {
            projectMenu.isHidden = false
        } else {
            projectMenu.isHidden = true
        }
    }
    
    @IBAction func jsButton_clicked(_ sender: UIButton) {
        if isIphone() {
            webViewContainer.isHidden = true
        }
        projectMenu.isHidden = true
        if (mode != "js") {
            html = codeField.text
            mode = "js"
            codeField.text = js
            syntaxHighlighting(codeField: self.codeField, mode: mode, line: -1, reset: true)
        }
    }
    
    @IBAction func htmlButton_clicked(_ sender: UIButton) {
        if isIphone() {
            webViewContainer.isHidden = true
        }
        projectMenu.isHidden = true
        if (mode != "html") {
            js = codeField.text
            mode = "html"
            codeField.text = html
            syntaxHighlighting(codeField: self.codeField, mode: mode, line: -1, reset: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        projectMenu.isHidden = true
        
        self.syntaxHighlighting(codeField: self.codeField, mode: mode, line: -1, reset: false)
        if (mode == "html") {
            html = codeField.text
        } else if (mode == "js") {
            js = codeField.text
        }
        save()
    }
    
    func save() {
        core.saveData(js,html: html,forName: projectname)
    }
    
    func load() {
        js = core.loadData("js", forName: projectname)
        html = core.loadData("html", forName: projectname)
        codeField.text = js;
        mode = "js";
        syntaxHighlighting(codeField: self.codeField, mode: mode, line: -1, reset: true)
        
        if isIphone() {
            webViewContainer.isHidden = true
        }
    }
    
    func newProject() {
        let alert = UIAlertController(title: "New project", message: "Give your new project a name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            self.js = "function setup() {\n\tcreateCanvas(400,400);\n}\n\nfunction draw() {\n\tbackground(0);\n}";
            self.html = "<html>\n\t<head>\n\t\t<script src='https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.16/p5.js'></script>\n\t\t<script src='https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.16/addons/p5.dom.js'></script>\n\t\t<script src='sketch.js'></script>\n\t</head>\n\t<body>\n\t</body>\n</html>";
            self.projectname = (alert?.textFields![0].text)!;
            self.save();
            
            self.codeField.text = self.js;
            self.mode = "js";
            self.syntaxHighlighting(codeField: self.codeField, mode: self.mode, line: -1, reset: true)
            
            DispatchQueue.main.async{
                self.projectTable.reloadData()
            }
            
            if self.isIphone() {
                self.webViewContainer.isHidden = true
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var runButton: UIButton!
    
    @IBAction func runButton_clicked(_ sender: UIButton) {
        view.endEditing(true)
        runButton.setTitle("loading..", for: .normal)
        projectMenu.isHidden = true
        
        if (mode == "html") {
            html = codeField.text
        } else if (mode == "js") {
            js = codeField.text
        }
        
        webView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
        
        var string:String! = "<style>html, body, canvas { -webkit-touch-callout: none; }</style>" + html
        let errorScript = "<script type='text/javascript'>var errorLine = -1; window.onerror = function (errorMsg, url, lineNumber) { errorLine = lineNumber; document.write('<br><font color=\"#F00\" style=\"font-size: 15px; font-family: monospace;\">Error: ' + errorMsg + '<br> Line: ' + lineNumber + '</font><br><br><hr><br>');}</script>";
        string = errorScript + "<script type='text/javascript'>" + js + "</script>" + string;
        webView.loadHTMLString(string, baseURL: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShowNotification(_ sender: NSNotification) {
        let userInfo = sender.userInfo!
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.bottomLayoutConstraint.constant = convertedKeyboardEndFrame.height
        }
    }
    
    func keyboardWillHideNotification(_ sender: NSNotification) {
        bottomLayoutConstraint.constant = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.characters.count > 1{
            let when = DispatchTime.now() + 0.75
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.syntaxHighlighting(codeField: self.codeField, mode: self.mode, line: -1, reset: true)
            }
        } else {
            if (text == "\n") {
                
                let nsstring = codeField.text! as NSString
                let linerange = nsstring.lineRange(for: codeField.cursorRange!)
                var indice = 0
                var block = false
                
                for i in 0 ..< linerange.length {
                    if nsstring.character(at: linerange.location + i) == (" " as NSString).character(at: 0) {
                        indice += 1
                    } else if nsstring.character(at: linerange.location + i) == ("\t" as NSString).character(at: 0) {
                        indice += 3
                    } else {
                        break
                    }
                }
                
                if nsstring.character(at: linerange.location + linerange.length-1) == ("\n" as NSString).character(at: 0) {
                    if nsstring.character(at: linerange.location + linerange.length-2) == ("{" as NSString).character(at: 0) {
                        indice += 3;
                        block = true;
                    }
                } else {
                    if nsstring.character(at: linerange.location + linerange.length-1) == ("{" as NSString).character(at: 0) {
                        indice += 3;
                        block = true;
                    }
                }
                
                textView.insertText("\n")
                
                for _ in 0 ..< indice/3 {
                    textView.insertText("\t")
                }
                for _ in 0 ..< indice - (indice/3)*3 {
                    textView.insertText(" ");
                }
                
                /*if (block) {
                 let cursor = textView.cursorRange
                 textView.insertText("\n")
                 
                 indice -= 3
                 for _ in 0 ..< indice/3 {
                 textView.insertText("\t")
                 }
                 for _ in 0 ..< indice - (indice/3)*3 {
                 textView.insertText(" ");
                 }
                 
                 textView.insertText("}")
                 
                 textView.selectedRange = cursor!
                 }*/
                
                return false;
            } else if (text == "’" || text == "'") {
                print("hi")
                textView.insertText("'");
                return false;
            } else if (text == "“" || text == "\"") {
                textView.insertText("\"");
                return false;
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return core.returnNames().count+1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row < core.returnNames().count {
            cell.textLabel?.text = core.returnNames()[indexPath.row]
        } else {
            cell.textLabel?.text = "+ new project"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath)?.textLabel?.text == "+ new project") {
            projectMenu.isHidden = true
            newProject()
        } else {
            projectMenu.isHidden = true
            projectname = core.returnNames()[indexPath.row]
            load()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < core.returnNames().count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let rename =  UITableViewRowAction(style: .normal, title: "Rename")
        { action, index in
            self.renameItem(indexPath.row)
        }
        rename.backgroundColor = UIColor.orange
        let delete =  UITableViewRowAction(style: .normal, title: "Delete")
        { action, index in
            self.deleteItem(indexPath.row)
        }
        delete.backgroundColor = UIColor.red
        return [delete, rename]
    }
    
    func deleteItem(_ index:Int) {
        
        let alert = UIAlertController(title: "Delete project", message: "Are you sure you want to delete '" + core.returnNames()[index] + "'", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak alert] (_) in
            core.deleteData(core.returnNames()[index])
            DispatchQueue.main.async{
                self.projectTable.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { [weak alert] (_) in
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func renameItem(_ index:Int) {
        let alert = UIAlertController(title: "Rename project", message: "Give your project a new name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = core.returnNames()[index]
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            if (self.projectname == core.returnNames()[index]) {
                self.projectname = (alert?.textFields![0].text)!;
            }
            core.renameData((alert?.textFields![0].text)!, forName: core.returnNames()[index])
            DispatchQueue.main.async{
                self.projectTable.reloadData()
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        runButton.setTitle("loading..", for: .normal)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        runButton.setTitle("Run code", for: .normal)
        if (isIphone()) {
            webViewContainer.isHidden = false
        }
        let errorLine = webView.stringByEvaluatingJavaScript(from: "errorLine")!
        if (errorLine != "") {
            let errorInt = Int(errorLine)!;
            syntaxHighlighting(codeField: self.codeField, mode: mode, line: errorInt, reset: true)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        runButton.setTitle("Run code", for: .normal)
        if isIphone() {
            webViewContainer.isHidden = false
        }
        webView.loadHTMLString("<font color='#FF0000'>" + error.localizedDescription + "</font>", baseURL: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
