const BASE64 = 'base64';
const files = ['IMM5476.pdf'];
const deleteFile = async (file) => await chrome.storage.local.remove(file);
const reset = async () => await chrome.storage.local.clear();
const set = async (key, val) => await chrome.storage.local.set({ [key]: val });
const get = async key => (await chrome.storage.local.get(key))?.[key] || '';

const fileSave = async (file, arrayBuffer) => {
    const base64File = Buffer.from(arrayBuffer).toString(BASE64);
    return await set(file, base64File);
};

const fileRead = async (file, verify) => {
    const b = (await get(file)) || null;
    return b && !verify ? new Uint8Array(Buffer.from(b, BASE64)).buffer : b;
};

const updateUI = async () => {
    for (let f of files) {
        const domName = f.replace(/\.[^\.]*$/, '');
        const fv = await fileRead(f, true);
        const html = $(`#file_${domName}`).html();
        const target = fv ? 'Remove' : 'Set';
        (html === target) || $(`#file_${domName}`).html(target);
    }
};

document.addEventListener('DOMContentLoaded', async () => {

    setInterval(updateUI, 1000);

    $('#folders').val(await get('folders'));

    $('#file_IMM5476').click(async (event) => {
        try {
            const filename = 'IMM5476.pdf';
            switch ($('#file_IMM5476').html()) {
                case 'Set':
                    const [fileHandle] = await window.showOpenFilePicker();
                    const arrBuf = await (await fileHandle.getFile()).arrayBuffer();
                    await fileSave(filename, arrBuf);
                    break;
                case 'Remove':
                    await (event.shiftKey ? reset() : deleteFile(filename));
            }
        } catch (e) { console.log(e); }
    });

    $('#folders_set').click(async () => await set(
        'folders', $('#folders').val()
    ));

});
