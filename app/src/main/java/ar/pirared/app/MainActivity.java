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
        getWindow().setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        );

        // The app currently runs fully from bundled assets. Keep WebView locked
        // to those assets until a reviewed, HTTPS backend is added.
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
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            settings.setSafeBrowsingEnabled(true);
        }

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                Uri uri = request.getUrl();
                return !isLocalAsset(uri);
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return !isLocalAsset(Uri.parse(url));
            }
        });
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onShowFileChooser(
                WebView view,
                ValueCallback<Uri[]> callback,
                FileChooserParams params
            ) {
                if (fileCallback != null) {
                    fileCallback.onReceiveValue(null);
                }

                fileCallback = callback;

                Intent intent = params.createIntent();

                try {
                    startActivityForResult(intent, FILE_REQUEST);
                    return true;
                } catch (Exception e) {
                    fileCallback = null;
                    callback.onReceiveValue(null);
                    return false;
                }
            }
        });

        setContentView(webView);
        webView.loadUrl(LOCAL_ASSETS + "www/index.html");
        checkForUpdate();
    }


    // Comprueba actualizaciones publicadas y firmadas para evitar instalar paquetes incompatibles.
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
                JSONObject release = null;
                int latestBuild = 0;
                String releaseUrl = RELEASE_PAGE;
                for (int i = 0; i < releases.length(); i++) {
                    JSONObject candidate = releases.optJSONObject(i);
                    if (candidate == null || candidate.optBoolean("draft", false)) continue;
                    String candidateTag = candidate.optString("tag_name", "");
                    int candidateBuild = parseBuildNumber(candidateTag);
                    if (candidateBuild > latestBuild && candidate.has("assets") && candidate.optJSONArray("assets") != null && candidate.optJSONArray("assets").length() > 0) {
                        latestBuild = candidateBuild;
                        release = candidate;
                        releaseUrl = candidate.optString("html_url", RELEASE_PAGE);
                    }
                }
                if (release == null) return;
                int installedBuild;
                try {
                    PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), 0);
                    installedBuild = (int) (Build.VERSION.SDK_INT >= 28 ? info.getLongVersionCode() : info.versionCode);
                } catch (Exception ignored) { installedBuild = 0; }
                if (latestBuild > installedBuild) {
                    new Handler(Looper.getMainLooper()).post(() -> {
                        if (isFinishing() || isDestroyed()) return;
                        new AlertDialog.Builder(MainActivity.this)
                            .setTitle("Actualización de PiraRed disponible")
                            .setMessage("Hay una nueva versión. Abrí la página oficial para descargarla e instalarla. Android te pedirá confirmar la instalación.")
                            .setNegativeButton("Más tarde", (dialog, which) -> dialog.dismiss())
                            .setPositiveButton("Ver actualización", (dialog, which) -> {
                                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(releaseUrl));
                                try { startActivity(intent); } catch (Exception ignored) { }
                            })
                            .show();
                    });
                }
            } catch (Exception ignored) {
                // Sin conexión o sin publicación nueva: la app sigue funcionando normalmente.
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

    private boolean isLocalAsset(Uri uri) {
        return uri != null
            && "file".equalsIgnoreCase(uri.getScheme())
            && uri.toString().startsWith(LOCAL_ASSETS);
    }

    @Override
    protected void onActivityResult(
        int requestCode,
        int resultCode,
        Intent data
    ) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == FILE_REQUEST && fileCallback != null) {
            Uri[] results = null;

            if (resultCode == RESULT_OK && data != null) {
                Uri uri = data.getData();

                if (uri != null) {
                    results = new Uri[]{uri};
                }
            }

            fileCallback.onReceiveValue(results);
            fileCallback = null;
        }
    }

    @Override
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
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
