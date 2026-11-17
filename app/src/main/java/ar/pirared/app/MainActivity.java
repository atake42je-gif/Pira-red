package ar.pirared.app;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebSettings;
import android.webkit.ValueCallback;
import android.content.Intent;
import android.net.Uri;
import android.view.Window;
import android.view.WindowManager;
import android.view.View;
import android.graphics.Color;
import android.webkit.WebResourceRequest;
import android.app.AlertDialog;
import android.content.pm.PackageInfo;
import android.os.Handler;
import android.os.Looper;
import org.json.JSONObject;
import org.json.JSONArray;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class MainActivity extends Activity {

    private WebView webView;
    private ValueCallback<Uri[]> fileCallback;
    private static final int FILE_REQUEST = 1001;
    private static final String LOCAL_ASSETS = "file:///android_asset/";
    private static final String RELEASE_API = "https://api.github.com/repos/atake42je-gif/Pira-red/releases?per_page=10";
    private static final String RELEASE_PAGE = "https://github.com/atake42je-gif/Pira-red/releases/latest";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().setStatusBarColor(Color.parseColor("#071b31"));
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            getWindow().setNavigationBarColor(Color.parseColor("#071b31"));
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().getDecorView().setSystemUiVisibility(0);
        }

        WebView.setWebContentsDebuggingEnabled(false);
        webView = new WebView(this);
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(false);
        settings.setAllowFileAccessFromFileURLs(false);
        settings.setAllowUniversalAccessFromFileURLs(false);
        settings.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) settings.setSafeBrowsingEnabled(true);

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                Uri uri = request.getUrl();
                if (isLocalAsset(uri)) return false;
                openExternalUrl(uri);
                return true;
            }
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Uri uri = Uri.parse(url);
                if (isLocalAsset(uri)) return false;
                openExternalUrl(uri);
                return true;
            }
        });
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onShowFileChooser(WebView view, ValueCallback<Uri[]> callback, FileChooserParams params) {
                if (fileCallback != null) fileCallback.onReceiveValue(null);
                fileCallback = callback;
                try {
                    startActivityForResult(params.createIntent(), FILE_REQUEST);
                    return true;
                } catch (Exception e) {
                    fileCallback = null;
                    callback.onReceiveValue(null);
                    return false;
                }
            }
        });

        setContentView(webView);
        webView.loadUrl(LOCAL_ASSETS + "www/pirared-mobile.html");
        checkForUpdate();
    }

    private void checkForUpdate() {
        new Thread(() -> {
            HttpURLConnection connection = null;
            try {
                connection = (HttpURLConnection) new URL(RELEASE_API).openConnection();
                connection.setRequestMethod("GET");
                connection.setConnectTimeout(6000);
                connection.setReadTimeout(6000);
                connection.setRequestProperty("Accept", "application/vnd.github+json");
                connection.setRequestProperty("User-Agent", "PiraRed-Android");
                if (connection.getResponseCode() != HttpURLConnection.HTTP_OK) return;
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
                StringBuilder body = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) body.append(line);
                reader.close();
                JSONArray releases = new JSONArray(body.toString());
                int latestBuild = 0;
                String releaseUrl = RELEASE_PAGE;
                for (int i = 0; i < releases.length(); i++) {
                    JSONObject candidate = releases.optJSONObject(i);
                    if (candidate == null || candidate.optBoolean("draft", false) || candidate.optBoolean("prerelease", false)) continue;
                    int candidateBuild = parseBuildNumber(candidate.optString("tag_name", ""));
                    JSONArray assets = candidate.optJSONArray("assets");
                    if (assets == null) continue;
                    for (int j = 0; j < assets.length(); j++) {
                        JSONObject asset = assets.optJSONObject(j);
                        if (asset == null || !asset.optString("name", "").toLowerCase().endsWith(".apk")) continue;
                        String url = asset.optString("browser_download_url", "");
                        if (candidateBuild > latestBuild && !url.isEmpty()) {
                            latestBuild = candidateBuild;
                            releaseUrl = url;
                        }
                    }
                }
                PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), 0);
                int installedBuild = (int) (Build.VERSION.SDK_INT >= 28 ? info.getLongVersionCode() : info.versionCode);
                if (latestBuild > installedBuild) {
                    final String updateUrl = releaseUrl;
                    new Handler(Looper.getMainLooper()).post(() -> {
                        if (isFinishing() || isDestroyed()) return;
                        new AlertDialog.Builder(MainActivity.this)
                            .setTitle("Hay una versión nueva de PiraRed")
                            .setMessage("Podés seguir usando la aplicación. Si querés, consultá la actualización.")
                            .setCancelable(true)
                            .setNegativeButton("Ahora no", (dialog, which) -> dialog.dismiss())
                            .setPositiveButton("Ver actualización", (dialog, which) -> {
                                try { startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(updateUrl))); }
                                catch (Exception ignored) { }
                            }).show();
                    });
                }
            } catch (Exception ignored) {
                // La comprobación de actualización no debe impedir el inicio.
            } finally {
                if (connection != null) connection.disconnect();
            }
        }, "PiraRed-update-check").start();
    }

    private int parseBuildNumber(String tag) {
        if (tag == null) return 0;
        String prefix = tag.startsWith("prueba-") ? "prueba-" : (tag.startsWith("build-") ? "build-" : null);
        if (prefix == null) return 0;
        try { return Integer.parseInt(tag.substring(prefix.length())); }
        catch (NumberFormatException ignored) { return 0; }
    }

    private void openExternalUrl(Uri uri) {
        if (uri == null) return;
        String scheme = uri.getScheme();
        if (!"https".equalsIgnoreCase(scheme) && !"http".equalsIgnoreCase(scheme)) return;
        try { startActivity(new Intent(Intent.ACTION_VIEW, uri)); }
        catch (Exception ignored) { }
    }

    private boolean isLocalAsset(Uri uri) {
        return uri != null && "file".equalsIgnoreCase(uri.getScheme()) && uri.toString().startsWith(LOCAL_ASSETS);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == FILE_REQUEST && fileCallback != null) {
            Uri[] results = null;
            if (resultCode == RESULT_OK && data != null && data.getData() != null) results = new Uri[]{data.getData()};
            fileCallback.onReceiveValue(results);
            fileCallback = null;
        }
    }

    @Override
    public void onBackPressed() {
        if (webView != null) {
            webView.evaluateJavascript("(function(){return window.piraredHandleBack ? window.piraredHandleBack() : 'exit';})()", value -> {
                if (value == null || value.contains("exit")) finish();
            });
        } else super.onBackPressed();
    }

    @Override
    protected void onDestroy() {
        if (fileCallback != null) {
            fileCallback.onReceiveValue(null);
            fileCallback = null;
        }
        if (webView != null) {
            webView.stopLoading();
            webView.setWebChromeClient(null);
            webView.setWebViewClient(null);
            webView.destroy();
            webView = null;
        }
        super.onDestroy();
    }
}
